using Godot;
using System;

public class Menu : CanvasLayer
{
    [Export]
    private Label scoreLabel;
    private Label messageLabel;
    private Button startButton;
    private Timer restartTimer;
    
    public override void _Ready()
    {
        scoreLabel = (Label) GetNode("ScoreLabel");

        messageLabel = (Label) GetNode("MessageLabel");

        startButton = (Button) GetNode("StartButton");
        startButton.Connect("pressed", this, nameof(OnStartButtonPressed));

        AddUserSignal("game_started");

        restartTimer = (Timer) GetNode("RestartTimer");
    }
    
    void OnStartButtonPressed()
    {
        messageLabel.Hide();

        startButton.Hide();

        EmitSignal("game_started");
    }

    public void UpdateScore(int score)
    {
        scoreLabel.Text = score.ToString();
    }

    public async void Gameover()
    {
        messageLabel.Text = "GAME OVER";
        messageLabel.Show();

        restartTimer.Start();

        await ToSignal(restartTimer, "timeout");

        messageLabel.Text = "Dodge The Creeps";

        startButton.Show();
    }
}