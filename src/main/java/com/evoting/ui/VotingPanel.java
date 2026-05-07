package com.evoting.ui;

import com.evoting.dao.AuditLogDAO;
import com.evoting.dao.CandidateDAO;
import com.evoting.dao.ElectionDAO;
import com.evoting.dao.TokenDAO;
import com.evoting.dao.VoteDAO;
import com.evoting.entity.Candidate;
import com.evoting.entity.Election;
import com.evoting.enums.ActionType;

import javax.swing.*;
import java.awt.*;
import java.util.List;
import java.util.Optional;

/**
 * Voting screen — shows candidates for the selected election.
 *
 * FIX #1  — loadCandidates(electionId) is called by MainFrame.showCard()
 *            before this panel becomes visible, so it always has the correct
 *            election loaded.
 * FIX #3  — ballotId is fetched from the DB for the current election instead
 *            of being hardcoded to 1. tokenId is retrieved after issuing the
 *            token so the correct value is stored in the vote record.
 * FIX #7  — Token is issued using the real ballotId from the DB.
 */
public class VotingPanel extends JPanel {

    private final MainFrame    frame;
    private final CandidateDAO candidateDAO = new CandidateDAO();
    private final ElectionDAO  electionDAO  = new ElectionDAO();
    private final TokenDAO     tokenDAO     = new TokenDAO();
    private final VoteDAO      voteDAO      = new VoteDAO();
    private final AuditLogDAO  auditLogDAO  = new AuditLogDAO();

    private final ButtonGroup candidateGroup = new ButtonGroup();
    private final JPanel      candidatePanel = new JPanel();
    private final JButton     btnSubmit      = new JButton("Submit Vote");
    private final JButton     btnBack        = new JButton("Back");
    private final JLabel      lblStatus      = new JLabel(" ");
    private final JLabel      lblElection    = new JLabel(" ", SwingConstants.CENTER);

    private int currentElectionId = -1;
    private int currentBallotId   = -1; // FIX #3 — fetched from DB, not hardcoded

    public VotingPanel(MainFrame frame) {
        this.frame = frame;
        setLayout(new BorderLayout(10, 10));
        buildUI();
        wireEvents();
    }

    private void buildUI() {
        // Header — election name displayed at top
        lblElection.setFont(new Font("SansSerif", Font.BOLD, 16));
        lblElection.setBorder(BorderFactory.createEmptyBorder(10, 0, 4, 0));

        JLabel title = new JLabel("Cast Your Vote", SwingConstants.CENTER);
        title.setFont(new Font("SansSerif", Font.BOLD, 18));
        title.setBorder(BorderFactory.createEmptyBorder(10, 0, 2, 0));

        JPanel header = new JPanel(new BorderLayout());
        header.add(title,       BorderLayout.NORTH);
        header.add(lblElection, BorderLayout.SOUTH);
        add(header, BorderLayout.NORTH);

        candidatePanel.setLayout(new BoxLayout(candidatePanel, BoxLayout.Y_AXIS));
        add(new JScrollPane(candidatePanel), BorderLayout.CENTER);

        lblStatus.setForeground(Color.RED);
        btnSubmit.setEnabled(false); // disabled until a candidate is selected

        JPanel bottom = new JPanel(new FlowLayout());
        bottom.add(lblStatus);
        bottom.add(btnBack);
        bottom.add(btnSubmit);
        add(bottom, BorderLayout.SOUTH);
    }

    private void wireEvents() {
        btnBack.addActionListener(e -> frame.showCard(MainFrame.CARD_ELECTIONS));

        btnSubmit.addActionListener(e -> {
            ButtonModel selected = candidateGroup.getSelection();
            if (selected == null) {
                lblStatus.setText("Please select a candidate.");
                return;
            }

            int candidateId = Integer.parseInt(selected.getActionCommand());

            int confirm = JOptionPane.showConfirmDialog(this,
                    "Confirm your vote? This cannot be undone.",
                    "Confirm Vote",
                    JOptionPane.YES_NO_OPTION);
            if (confirm != JOptionPane.YES_OPTION) return;

            btnSubmit.setEnabled(false);
            btnBack.setEnabled(false);

            // Capture final values for use inside SwingWorker
            int electionId = currentElectionId;
            int ballotId   = currentBallotId;   // FIX #3 — real ballotId
            int voterId    = frame.getCurrentVoterId();

            SwingWorker<Void, Void> worker = new SwingWorker<>() {
                @Override
                protected Void doInBackground() throws Exception {
                    // FIX #7 — token issued with real ballotId
                    String tokenValue = tokenDAO.issueToken(electionId, ballotId);

                    // Consume token atomically — fails if already used
                    boolean consumed = tokenDAO.consumeToken(tokenValue);
                    if (!consumed) throw new Exception("Token already used.");

                    // FIX #3 — fetch the token_id from DB to store in the vote record
                    int tokenId = tokenDAO.findTokenIdByValue(tokenValue);
                    if (tokenId == -1) throw new Exception("Token not found after insert.");

                    // Encrypt the vote (placeholder — replace with real encryption)
                    String encrypted = "ENC:sha256$" + candidateId + ":" + System.currentTimeMillis();

                    // FIX #3 — castVote now receives real ballotId and tokenId
                    voteDAO.castVote(candidateId, electionId, ballotId, tokenId, encrypted);

                    // Audit log
                    auditLogDAO.log(voterId, ActionType.VOTE,
                            "Voted for candidate " + candidateId + " in election " + electionId);
                    return null;
                }

                @Override
                protected void done() {
                    btnBack.setEnabled(true);
                    try {
                        get();
                        JOptionPane.showMessageDialog(VotingPanel.this,
                                "Your vote has been recorded. Thank you!");
                        frame.showCard(MainFrame.CARD_ELECTIONS);
                    } catch (Exception ex) {
                        lblStatus.setText("Vote failed: " + ex.getMessage());
                        btnSubmit.setEnabled(true);
                    }
                }
            };
            worker.execute();
        });
    }

    /**
     * Loads candidates for the given election from DB.
     * FIX #1  — Called by MainFrame.showCard() before switching to this panel.
     * FIX #3  — Also fetches the ballotId for this election from DB.
     * FIX #7  — ballotId stored in currentBallotId for use during vote submission.
     */
    public void loadCandidates(int electionId) {
        this.currentElectionId = electionId;
        this.currentBallotId   = -1; // reset until fetched
        candidatePanel.removeAll();
        candidateGroup.clearSelection();
        btnSubmit.setEnabled(false);
        lblStatus.setText(" ");

        SwingWorker<List<Candidate>, Void> worker = new SwingWorker<>() {
            private int fetchedBallotId = -1;

            @Override
            protected List<Candidate> doInBackground() throws Exception {
                // FIX #3 / #7 — fetch real ballotId for this election
                fetchedBallotId = electionDAO.findBallotIdByElection(electionId);

                // Also show election name in header
                Optional<Election> electionOpt = electionDAO.findById(electionId);
                electionOpt.ifPresent(e ->
                        SwingUtilities.invokeLater(() ->
                                lblElection.setText(e.getElectionName())));

                return candidateDAO.findByElection(electionId);
            }

            @Override
            protected void done() {
                try {
                    currentBallotId = fetchedBallotId; // FIX #3

                    List<Candidate> candidates = get();
                    if (candidates.isEmpty()) {
                        lblStatus.setText("No candidates found for this election.");
                        return;
                    }

                    for (Candidate c : candidates) {
                        JRadioButton rb = new JRadioButton(
                                c.getFullName() + "  (" + c.getPartyAffiliation() + ")");
                        rb.setActionCommand(String.valueOf(c.getCandidateId()));
                        rb.addActionListener(e -> btnSubmit.setEnabled(true));
                        candidateGroup.add(rb);

                        // Add candidate card with manifesto hint
                        JPanel card = new JPanel(new BorderLayout(4, 4));
                        card.setBorder(BorderFactory.createEmptyBorder(6, 10, 6, 10));
                        card.add(rb, BorderLayout.NORTH);
                        if (c.getManifesto() != null && !c.getManifesto().isBlank()) {
                            JLabel lbl = new JLabel("<html><i>" + c.getManifesto() + "</i></html>");
                            lbl.setForeground(Color.DARK_GRAY);
                            lbl.setBorder(BorderFactory.createEmptyBorder(0, 20, 0, 0));
                            card.add(lbl, BorderLayout.CENTER);
                        }
                        candidatePanel.add(card);
                        candidatePanel.add(new JSeparator());
                    }
                    candidatePanel.revalidate();
                    candidatePanel.repaint();
                } catch (Exception ex) {
                    lblStatus.setText("Failed to load candidates: " + ex.getMessage());
                }
            }
        };
        worker.execute();
    }
}
