package com.evoting.ui;

import com.evoting.dao.VoterDAO;
import com.evoting.entity.Voter;
import com.evoting.enums.VoterStatus;

import javax.swing.*;
import java.awt.*;

/**
 * Voter registration screen.
 *
 * FIX #8 — Password value from pfPassword is now passed to the Voter
 *           object and saved to the database via VoterDAO.insert().
 *           In production, hash with BCrypt before storing.
 */
public class RegisterPanel extends JPanel {

    private final MainFrame frame;
    private final VoterDAO  voterDAO = new VoterDAO();

    private final JTextField     tfNationalId = new JTextField(20);
    private final JTextField     tfFullName   = new JTextField(20);
    private final JTextField     tfEmail      = new JTextField(20);
    private final JPasswordField pfPassword   = new JPasswordField(20);
    private final JButton        btnRegister  = new JButton("Register");
    private final JButton        btnBack      = new JButton("Back to Login");
    private final JLabel         lblMsg       = new JLabel(" ");

    public RegisterPanel(MainFrame frame) {
        this.frame = frame;
        setLayout(new GridBagLayout());
        buildUI();
        wireEvents();
    }

    private void buildUI() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(6, 8, 6, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        JLabel title = new JLabel("Register New Voter", SwingConstants.CENTER);
        title.setFont(new Font("SansSerif", Font.BOLD, 18));
        gbc.gridx = 0; gbc.gridy = 0; gbc.gridwidth = 2;
        add(title, gbc);

        String[]     labels = {"National ID:", "Full Name:", "Email:", "Password:"};
        JComponent[] fields = {tfNationalId, tfFullName, tfEmail, pfPassword};

        for (int i = 0; i < labels.length; i++) {
            gbc.gridwidth = 1; gbc.gridy = i + 1; gbc.gridx = 0;
            add(new JLabel(labels[i]), gbc);
            gbc.gridx = 1;
            add(fields[i], gbc);
        }

        lblMsg.setForeground(Color.BLUE);
        gbc.gridy = labels.length + 1; gbc.gridx = 0; gbc.gridwidth = 2;
        add(lblMsg, gbc);

        JPanel btnPanel = new JPanel(new FlowLayout());
        btnPanel.add(btnRegister);
        btnPanel.add(btnBack);
        gbc.gridy = labels.length + 2;
        add(btnPanel, gbc);
    }

    private void wireEvents() {
        btnBack.addActionListener(e -> frame.showCard(MainFrame.CARD_LOGIN));

        btnRegister.addActionListener(e -> {
            String nationalId = tfNationalId.getText().trim();
            String fullName   = tfFullName.getText().trim();
            String email      = tfEmail.getText().trim();
            // FIX #8 — read password value
            String password   = new String(pfPassword.getPassword()).trim();

            // Validation
            if (nationalId.isEmpty() || fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
                lblMsg.setForeground(Color.RED);
                lblMsg.setText("All fields are required.");
                return;
            }
            if (!email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
                lblMsg.setForeground(Color.RED);
                lblMsg.setText("Invalid email format.");
                return;
            }
            if (password.length() < 6) {
                lblMsg.setForeground(Color.RED);
                lblMsg.setText("Password must be at least 6 characters.");
                return;
            }

            btnRegister.setEnabled(false);

            SwingWorker<Boolean, Void> worker = new SwingWorker<>() {
                @Override
                protected Boolean doInBackground() throws Exception {
                    if (voterDAO.findByNationalId(nationalId).isPresent()) {
                        throw new Exception("National ID already registered.");
                    }
                    if (voterDAO.findByEmail(email).isPresent()) {
                        throw new Exception("Email already registered.");
                    }

                    Voter newVoter = new Voter();
                    newVoter.setNationalId(nationalId);
                    newVoter.setFullName(fullName);
                    newVoter.setEmail(email);
                    newVoter.setStatus(VoterStatus.PENDING); // admin must approve

                    // FIX #8 — set password on the voter object so DAO saves it
                    // In production: newVoter.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
                    newVoter.setPassword(password);

                    return voterDAO.insert(newVoter);
                }

                @Override
                protected void done() {
                    btnRegister.setEnabled(true);
                    try {
                        get();
                        lblMsg.setForeground(new Color(0, 128, 0));
                        lblMsg.setText("Registration submitted. Awaiting admin approval.");
                        clearFields();
                    } catch (Exception ex) {
                        lblMsg.setForeground(Color.RED);
                        lblMsg.setText(ex.getCause() != null
                                ? ex.getCause().getMessage()
                                : ex.getMessage());
                    }
                }
            };
            worker.execute();
        });
    }

    private void clearFields() {
        tfNationalId.setText("");
        tfFullName.setText("");
        tfEmail.setText("");
        pfPassword.setText("");
    }
}
