package com.evoting.ui;

import com.evoting.dao.AuditLogDAO;
import com.evoting.dao.VoterDAO;
import com.evoting.entity.Voter;
import com.evoting.enums.ActionType;
import com.evoting.enums.VoterStatus;

import javax.swing.*;
import java.awt.*;
import java.util.Optional;

/**
 * Login screen.
 *
 * FIX #4 — Password is now read from the voter record's password field
 *           instead of a hardcoded "password123" placeholder.
 *           (VoterDAO.findByNationalId returns the voter; password field
 *            on Voter is compared here. In production, use BCrypt.)
 */
public class LoginPanel extends JPanel {

    private final MainFrame   frame;
    private final VoterDAO    voterDAO    = new VoterDAO();
    private final AuditLogDAO auditLogDAO = new AuditLogDAO();

    private final JTextField     tfNationalId = new JTextField(20);
    private final JPasswordField pfPassword   = new JPasswordField(20);
    private final JButton        btnLogin     = new JButton("Login");
    private final JButton        btnRegister  = new JButton("Register");
    private final JLabel         lblError     = new JLabel(" ");

    public LoginPanel(MainFrame frame) {
        this.frame = frame;
        setLayout(new GridBagLayout());
        buildUI();
        wireEvents();
    }

    private void buildUI() {
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill   = GridBagConstraints.HORIZONTAL;

        // Title
        JLabel title = new JLabel("E-Voting System", SwingConstants.CENTER);
        title.setFont(new Font("SansSerif", Font.BOLD, 22));
        gbc.gridx = 0; gbc.gridy = 0; gbc.gridwidth = 2;
        add(title, gbc);

        // National ID
        gbc.gridwidth = 1; gbc.gridy = 1; gbc.gridx = 0;
        add(new JLabel("National ID:"), gbc);
        gbc.gridx = 1;
        add(tfNationalId, gbc);

        // Password
        gbc.gridy = 2; gbc.gridx = 0;
        add(new JLabel("Password:"), gbc);
        gbc.gridx = 1;
        add(pfPassword, gbc);

        // Error label (red)
        lblError.setForeground(Color.RED);
        gbc.gridy = 3; gbc.gridx = 0; gbc.gridwidth = 2;
        add(lblError, gbc);

        // Buttons
        JPanel btnPanel = new JPanel(new FlowLayout());
        btnPanel.add(btnLogin);
        btnPanel.add(btnRegister);
        gbc.gridy = 4;
        add(btnPanel, gbc);
    }

    private void wireEvents() {
        btnLogin.addActionListener(e -> doLogin());
        pfPassword.addActionListener(e -> doLogin()); // Enter key in password field
        btnRegister.addActionListener(e -> frame.showCard(MainFrame.CARD_REGISTER));
    }

    private void doLogin() {
        String nationalId = tfNationalId.getText().trim();
        String password   = new String(pfPassword.getPassword()).trim();

        if (nationalId.isEmpty() || password.isEmpty()) {
            lblError.setText("Please enter National ID and password.");
            return;
        }

        btnLogin.setEnabled(false);
        lblError.setText(" ");

        SwingWorker<Optional<Voter>, Void> worker = new SwingWorker<>() {
            @Override
            protected Optional<Voter> doInBackground() throws Exception {
                return voterDAO.findByNationalId(nationalId);
            }

            @Override
            protected void done() {
                btnLogin.setEnabled(true);
                try {
                    Optional<Voter> result = get();

                    if (result.isEmpty()) {
                        lblError.setText("National ID not found.");
                        return;
                    }

                    Voter voter = result.get();

                    // FIX #4 — compare against the voter's stored password field
                    // voter.getPassword() is the hashed/plain password from DB.
                    // Replace with BCrypt.checkpw(password, voter.getPassword())
                    // in a production environment.
                    if (!password.equals(voter.getPassword())) {
                        lblError.setText("Incorrect password.");
                        return;
                    }

                    if (voter.getStatus() != VoterStatus.ACTIVE) {
                        lblError.setText("Account is " + voter.getStatus().name() + ". Contact admin.");
                        return;
                    }

                    // Login successful
                    frame.setCurrentVoterId(voter.getVoterId());
                    auditLogDAO.log(voter.getVoterId(), ActionType.LOGIN, "Login from UI");
                    frame.showCard(MainFrame.CARD_ELECTIONS);

                } catch (Exception ex) {
                    lblError.setText("Database error: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
        };
        worker.execute();
    }
}
