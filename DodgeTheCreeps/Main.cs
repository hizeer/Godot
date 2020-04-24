using Godot;
using System;

public class Main : Node2D
{
    [Export]
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
    private Godot.Object myNetwork;
    private Godot.Object myGamestate;
    private VBoxContainer boxList;
    private Label nomJoueur;

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

        // Connecter le signal réseau avec le changement de la liste des joueurs

        foreach (Node p in GetTree().GetRoot().GetChildren()) 
        {
            GD.Print(p.GetMetaList());

            if(p.HasMeta("network"))
            {
                myNetwork = p;
            }

            else if(p.HasMeta("gamestate"))
            {
                myGamestate = p;
            }
        }
    
        myNetwork.Connect("modification_liste_joueurs", this, nameof(listeJoueurModification));

        // Mettre à jour le label pour afficher le joueur local
        nomJoueur = (Label) GetNode("HUD/PanelListeJoueurs/LabelJoueurLocal");
        var dico = (Godot.Collections.Dictionary) myGamestate.Get("infos_joueur");
        nomJoueur.Text = (String) dico["nom"];
    }

    public void OnEnnemiSpawn()
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

    public void Gameover()
    {
        music.Stop();

        deathSound.Play();

        joueur.Hide();

        scoreTimer.Stop();

        ennemiTimer.Stop();

        cleanEnnemies();

        menu.Gameover();
    }

    public void cleanEnnemies()
    {
        foreach(Node child in GetChildren())
        {
            if(child is Ennemi)
            {
                child.QueueFree();
            }
        }
    }

    public void OnGameStart()
    {
        music.Play();

        score = 0;
        menu.UpdateScore(score);

        joueur.SetPosition(startPosition.GetPosition());
        joueur.Show();

        scoreTimer.Start();

        ennemiTimer.Start();
    }

    public void OnScoreChange()
    {
        score += 1;
        menu.UpdateScore(score);
    }

    public void listeJoueurModification()
    {
        boxList = (VBoxContainer) GetNode("HUD/PanelListeJoueurs/Boxlist");

        // Supprimer tous les enfants de la boxList
        foreach(Node c in boxList.GetChildren())
        {
            c.QueueFree();
        }

        // Ajouter une nouvelle entrée pour chaque joueur dans la boxList
        var dicoJoueur = (Godot.Collections.Dictionary) myNetwork.Get("players");

        var dicoInfo = (Godot.Collections.Dictionary) myGamestate.Get("infos_joueur");

        foreach(System.Int32 p in dicoJoueur.Keys)
        {    
            if(p != (System.Int32) dicoInfo["net_id"])
            {
                var labelJoueur = new Label();
                var Joueur = (Godot.Collections.Dictionary) dicoJoueur[p];
                labelJoueur.Text = (String) Joueur["nom"];
                boxList.AddChild(labelJoueur);
            }
        }
    }
}