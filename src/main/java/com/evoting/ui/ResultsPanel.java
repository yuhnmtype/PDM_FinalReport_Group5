package com.evoting.ui;

import com.evoting.dao.CandidateDAO;
import com.evoting.dao.VoteDAO;
import com.evoting.entity.Candidate;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.Map;
import java.util.Optional;

/**
 * Election results screen.
 *
 * FIX #6 — Results table now shows the candidate's full name and party
 *           instead of just the raw candidate_id integer.
 *           CandidateDAO.findById() is called for each result row.
 */
public class ResultsPanel extends JPanel {

    private final MainFrame     frame;
    private final VoteDAO       voteDAO      = new VoteDAO();
    private final CandidateDAO  candidateDAO = new CandidateDAO(); // FIX #6

    private final JTextField        tfElectionId = new JTextField(8);
    private final JButton           btnLoad      = new JButton("Load Results");
    private final JButton           btnBack      = new JButton("Back");

    // FIX #6 — added "Candidate Name" and "Party" columns
    private final DefaultTableModel tableModel = new DefaultTableModel(
            new String[]{"Candidate Name", "Party", "Total Votes"}, 0) {
        @Override public boolean isCellEditable(int r, int c) { return false; }
    };

    private final JTable table    = new JTable(tableModel);
    private final JLabel lblTotal = new JLabel("Total votes: —");

    public ResultsPanel(MainFrame frame) {
        this.frame = frame;
        setLayout(new BorderLayout(10, 10));
        buildUI();
        wireEvents();
    }

    private void buildUI() {
        JLabel title = new JLabel("Election Results", SwingConstants.CENTER);
        title.setFont(new Font("SansSerif", Font.BOLD, 18));
        title.setBorder(BorderFactory.createEmptyBorder(10, 0, 10, 0));
        add(title, BorderLayout.NORTH);

        JPanel searchBar = new JPanel(new FlowLayout(FlowLayout.LEFT));
        searchBar.add(new JLabel("Election ID:"));
        searchBar.add(tfElectionId);
        searchBar.add(btnLoad);
        searchBar.add(btnBack);
        add(searchBar, BorderLayout.BEFORE_FIRST_LINE);

        // Adjust column widths
        table.setRowHeight(28);
        table.getColumnModel().getColumn(0).setPreferredWidth(200); // Name
        table.getColumnModel().getColumn(1).setPreferredWidth(160); // Party
        table.getColumnModel().getColumn(2).setPreferredWidth(100); // Votes
        add(new JScrollPane(table), BorderLayout.CENTER);

        lblTotal.setBorder(BorderFactory.createEmptyBorder(6, 10, 6, 0));
        add(lblTotal, BorderLayout.SOUTH);
    }

    private void wireEvents() {
        btnBack.addActionListener(e -> frame.showCard(MainFrame.CARD_ELECTIONS));

        btnLoad.addActionListener(e -> {
            String idText = tfElectionId.getText().trim();
            if (idText.isEmpty()) {
                JOptionPane.showMessageDialog(this, "Enter an election ID.");
                return;
            }
            int electionId;
            try {
                electionId = Integer.parseInt(idText);
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Election ID must be a number.");
                return;
            }

            btnLoad.setEnabled(false);
            tableModel.setRowCount(0);
            lblTotal.setText("Loading…");

            int finalElectionId = electionId;

            SwingWorker<Map<Integer, Integer>, Void> worker = new SwingWorker<>() {
                @Override
                protected Map<Integer, Integer> doInBackground() throws Exception {
                    return voteDAO.countVotesByElection(finalElectionId);
                }

                @Override
                protected void done() {
                    btnLoad.setEnabled(true);
                    try {
                        Map<Integer, Integer> results = get();

                        if (results.isEmpty()) {
                            lblTotal.setText("No votes recorded for this election.");
                            return;
                        }

                        int total = 0;
                        for (Map.Entry<Integer, Integer> entry : results.entrySet()) {
                            int candidateId = entry.getKey();
                            int votes       = entry.getValue();
                            total += votes;

                            // FIX #6 — look up candidate name and party from DB
                            String name  = "Unknown";
                            String party = "—";
                            try {
                                Optional<Candidate> cOpt = candidateDAO.findById(candidateId);
                                if (cOpt.isPresent()) {
                                    name  = cOpt.get().getFullName();
                                    party = cOpt.get().getPartyAffiliation() != null
                                            ? cOpt.get().getPartyAffiliation() : "—";
                                }
                            } catch (Exception ignore) { /* keep "Unknown" */ }

                            tableModel.addRow(new Object[]{name, party, votes});
                        }
                        lblTotal.setText("Total votes: " + total);

                    } catch (Exception ex) {
                        lblTotal.setText("Failed to load results.");
                        JOptionPane.showMessageDialog(ResultsPanel.this,
                                "Failed to load results: " + ex.getMessage());
                    }
                }
            };
            worker.execute();
        });
    }
}
