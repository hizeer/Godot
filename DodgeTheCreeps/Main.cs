using Godot;
using System;

public class Main : Node2D
{
    private Timer ennemiTimer;
    private Timer scoreTimer;
    private PackedScene ennemiScene;

    private PathFollow2D path;

    private Joueur joueur;

    private int score;

    private Menu menu;

    private Position2D startPosition;

    private static Random ennemiPosRandom;
    private static Random ennemiAngleRandom;

    private AudioStreamPlayer music;

    private AudioStreamPlayer deathSound;

    private GDScript NetworkNode;

    private GDScript GamestateNode;

    private Label ListeJoueur;

    private VBoxContainer boxList;

    public override void _Ready()
    {
        ennemiTimer = (Timer) GetNode("EnnemiTimer");
        ennemiTimer.Connect("timeout", this, nameof(OnEnnemiSpawn));
        

        scoreTimer = (Timer) GetNode("ScoreTimer");
        scoreTimer.Connect("timeout", this, nameof(OnScoreChange));
        ennemiScene = (PackedScene) GD.Load("Ennemi.tscn");  

        path = (PathFollow2D) GetNode("Path2D/PathFollow2D");

        joueur = (Joueur) GetNode("Joueur");
        joueur.Connect("hit", this, nameof(Gameover));

        menu = (Menu) GetNode("Menu");
        menu.Connect("game_started", this, nameof(OnGameStart));

        startPosition = (Position2D) GetNode("StartPosition");

        joueur.Hide();

        music = (AudioStreamPlayer) GetNode("Music");
        deathSound = (AudioStreamPlayer) GetNode("DeathSound");
        

        ennemiPosRandom = new Random(); 
        ennemiAngleRandom = new Random();

        // Connexion du signal de modification_liste_joueurs avec la fonction changement_liste_joueur
        NetworkNode = (GDScript) GD.Load("res://network.gd");
        NetworkNode.Connect("modification_liste_joueurs",this,"ChangementListeJoueur");

        // Mise à jour du LabelJoueurLocal pour afficher le joueur local
        ListeJoueur = (Label) GetNode("LabelJoueurLocal");
        GamestateNode = (GDScript) GD.Load("res://gamestate.gd");
        ListeJoueur.Text = (String) GamestateNode.Get("infos_joueur[name]");

    }

    void OnEnnemiSpawn()
    {
        path.SetOffset(ennemiPosRandom.Next());

        Vector2 position = path.GetPosition();

        float rotation = path.GetRotation() - Mathf.Deg2Rad(90 + ennemiAngleRandom.Next(-45, 45));

        Ennemi ennemi = (Ennemi) ennemiScene.Instance();

        ennemi.SetPosition(position);
        ennemi.SetLinearVelocity(new Vector2(200, 0).Rotated(rotation));
        ennemi.SetRotation(rotation);

        AddChild(ennemi);
    }

    void Gameover()
    {
        music.Stop();
        deathSound.Play();
        joueur.Hide();
        scoreTimer.Stop();
        ennemiTimer.Stop();
        cleanEnnemies();
        menu.Gameover();
    }

    void cleanEnnemies()
    {
        foreach(Node child in GetChildren())
        {
            if(child is Ennemi)
            {
                child.QueueFree();
            }
        }
    }

    void OnGameStart()
    {
        music.Play();
        score = 0;
        menu.UpdateScore(score);
        joueur.SetPosition(startPosition.GetPosition());
        joueur.Show();
        scoreTimer.Start();
        ennemiTimer.Start();
    }

    void OnScoreChange()
    {
        score += 1;
        menu.UpdateScore(score);
    }

    void ChangementListeJoueur()
    {
        boxList = (VBoxContainer) GetNode("BoxList")
        // Supprime tous les enfants de la boxList
        foreach(Node child in GetChildren())
        {
            if (child is VBoxContainer)
            {
                child.QueueFree();
            }
        }

        // Créé une nouvelle entrée dans la boxList
        foreach(GDScript child in GetChildren())
        {
            if (child == NetworkNode)
            {
                if (child != GamestateNode.Get("infos_joueur[net_id]"))
                {
                    private Label lbNouveauJoueur = new Label();
                    
                    lbNouveauJoueur.Text = NetworkNode.Get("chat");
                }
            }
        }
    }
}