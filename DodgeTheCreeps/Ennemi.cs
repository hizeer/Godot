using Godot;
using System;

public class Ennemi : RigidBody2D
{
    private static string[] animations = {"marche", "vol", "nage"};

    private AnimatedSprite animatedSprite;

    private VisibilityNotifier2D visibility;

    private static Random animationRandom = new Random();

    public override void _Ready()
    {
        animatedSprite = (AnimatedSprite) GetNode("AnimatedSprite");
        visibility = (VisibilityNotifier2D) GetNode("VisibilityNotifier2D");
        visibility.Connect("screen_exited", this, nameof(OnScreenExited));
        animatedSprite.Animation = animations[animationRandom.Next(0,animations.Length)];
        animatedSprite.Play();
    }

    void OnScreenExited()
    {
        QueueFree();
    }
}
