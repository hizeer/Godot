using Godot;
using System;

public class Joueur : Area2D
{
  [Export]
  private int SPEED = 400;
  private AnimatedSprite animatedSprite;
  private CollisionShape2D collisionShape2D;  
  private Vector2 velocity;
  private Vector2 screenSize;
  private Particles2D particles2D;

	public override void _Ready()
	{
    screenSize = GetViewportRect().Size;
    animatedSprite = (AnimatedSprite) GetNode("AnimatedSprite");
    collisionShape2D = (CollisionShape2D) GetNode("CollisionShape2D");
    particles2D = (Particles2D) GetNode("Particles2D");
    Connect("body_entered", this, nameof(OnBodyEntered));
    AddUserSignal("hit");
  }

  public override void _Process(float delta)
  {
    velocity = new Vector2();
    if (Input.IsActionPressed("ui_right"))
    {
      velocity.x += 1;
    }

    if(Input.IsActionPressed("ui_left"))
    {
      velocity.x -= 1;
    }

    if(Input.IsActionPressed("ui_up"))
    {
      velocity.y -= 1;
    }

    if(Input.IsActionPressed("ui_down"))
    {
      velocity.y += 1;
    }

    if(velocity.Length() > 0)
    {
      velocity = velocity.Normalized() * SPEED;
      animatedSprite.Play();
      particles2D.SetEmitting(true);
    }

    else
    {
      animatedSprite.Stop();
      particles2D.SetEmitting(false);
    }

    Position += velocity * delta;

    Position = new Vector2(
      Mathf.Clamp(Position.x, 0, screenSize.x),
      Mathf.Clamp(Position.y, 0, screenSize.y)
    );

    if(velocity.x != 0)
    {
      animatedSprite.Animation = "droite";
      animatedSprite.FlipH = velocity.x < 0;
      animatedSprite.FlipV = false;
    }

    else if(velocity.y != 0)
    {
      animatedSprite.Animation = "haut";
      animatedSprite.FlipV = velocity.y > 0;
    }
    
  }

  void OnBodyEntered(PhysicsBody2D body)
  {
    EmitSignal("hit");
  }
}