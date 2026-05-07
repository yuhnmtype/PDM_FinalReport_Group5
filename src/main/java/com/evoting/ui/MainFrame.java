package com.evoting.ui;

import com.evoting.util.DatabaseConnection;

import javax.swing.*;
import java.awt.*;

/**
 * Main application window.
 * Uses CardLayout to switch between screens without opening new windows.
 *
 * FIX #2  — Added currentElectionId field + getter/setter.
 * FIX #10 — Panel instances saved as fields so methods (loadElections,
 *            loadCandidates) can be called before switching cards.
 * FIX #5  — showCard() auto-calls loadElections() when navigating to
 *            the election list, so data always refreshes.
 */
public class MainFrame extends JFrame {

    public static final String CARD_LOGIN            = "LOGIN";
    public static final String CARD_REGISTER         = "REGISTER";
    public static final String CARD_ELECTIONS        = "ELECTIONS";
    public static final String CARD_VOTING           = "VOTING";
    public static final String CARD_RESULTS          = "RESULTS";
    public static final String CARD_CHANGE_PASSWORD  = "CHANGE_PASSWORD";

    private final CardLayout cardLayout = new CardLayout();
    private final JPanel     cardPanel  = new JPanel(cardLayout);

    // FIX #10 — keep named references so we can call methods on them
    private final LoginPanel            loginPanel            = new LoginPanel(this);
    private final RegisterPanel         registerPanel         = new RegisterPanel(this);
    private final ElectionListPanel     electionListPanel     = new ElectionListPanel(this);
    private final VotingPanel           votingPanel           = new VotingPanel(this);
    private final ResultsPanel          resultsPanel          = new ResultsPanel(this);
    private final ChangePasswordPanel   changePasswordPanel   = new ChangePasswordPanel(this);

    // Shared state
    private int currentVoterId    = -1;
    private int currentElectionId = -1; // FIX #2

    public MainFrame() {
        super("E-Voting System");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setSize(800, 600);
        setLocationRelativeTo(null);
        setResizable(false);

        // FIX #10 — add saved panel references
        cardPanel.add(loginPanel,          CARD_LOGIN);
        cardPanel.add(registerPanel,       CARD_REGISTER);
        cardPanel.add(electionListPanel,   CARD_ELECTIONS);
        cardPanel.add(votingPanel,         CARD_VOTING);
        cardPanel.add(resultsPanel,        CARD_RESULTS);
        cardPanel.add(changePasswordPanel, CARD_CHANGE_PASSWORD);

        add(cardPanel);

        // Close DB connection cleanly on exit
        addWindowListener(new java.awt.event.WindowAdapter() {
            @Override
            public void windowClosing(java.awt.event.WindowEvent e) {
                DatabaseConnection.close();
            }
        });

        showCard(CARD_LOGIN);
    }

    /**
     * Switches the visible panel.
     * FIX #5 — auto-refreshes election list every time that card is shown.
     * FIX #1 — loads candidates into VotingPanel before showing it.
     */
    public void showCard(String cardName) {
        if (CARD_ELECTIONS.equals(cardName)) {
            electionListPanel.loadElections();
        }
        if (CARD_VOTING.equals(cardName) && currentElectionId != -1) {
            votingPanel.loadCandidates(currentElectionId);
        }
        if (CARD_CHANGE_PASSWORD.equals(cardName)) {
            changePasswordPanel.clearFields();
        }
        cardLayout.show(cardPanel, cardName);
    }

    // ── Shared state accessors ────────────────────────────────────────────────

    public int getCurrentVoterId() { return currentVoterId; }
    public void setCurrentVoterId(int id) { this.currentVoterId = id; }

    // FIX #2
    public int getCurrentElectionId() { return currentElectionId; }
    public void setCurrentElectionId(int id) { this.currentElectionId = id; }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new MainFrame().setVisible(true));
    }
}