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

    private GDScript menuMultiplayer = (GDScript) GD.Load("res://MenuMultiplayer.gd");

    private Godot.Object myNetwork;

    private Godot.Object myMenuMultiplayer;

    private Godot.Object myGamestate;

    private VBoxContainer boxList;
    
    private LineEdit Serveur; 

    private SpinBox maxJoueur;

    private LineEdit rejoindre; 

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

        myGamestate = (Godot.Object) GetTree().GetRoot().GetChild(0);

        myNetwork = (Godot.Object) GetTree().GetRoot().GetChild(1);
        myNetwork.Connect("modification_liste_joueurs", this, nameof(listeJoueurModification));

        // Mettre à jour le label pour afficher le joueur local
        nomJoueur = (Label) GetNode("HUD/PanelListeJoueurs/LabelJoueurLocal");
        nomJoueur.Text = (String) myGamestate.Get("infos_joueurs[nom]");
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
        foreach(Godot.Collections.Dictionary p in (Godot.Collections.Dictionary) myNetwork.Get("players"))
        {
            if(p != myGamestate.Get("infos_joueur[net_id]"))
            {
                var labelJoueur = new Label();
                labelJoueur.Text = (String) myNetwork.Get("players[p][nom]");
                boxList.AddChild(labelJoueur);
            }
        }
    }

    public void _on_btCreer_pressed()
    {
        // maj info joueur local
        foreach(Node n in GetTree().GetRoot().GetChildren())
        {
            GD.Print(n);
            GD.Print("\n");
        }
        
        myMenuMultiplayer = (Godot.Object) menuMultiplayer.New();
        myMenuMultiplayer.Call("set_player_info");
        Serveur = (LineEdit) GetNode("res://MenuMultiplayer.tscn/CanvasLayer/PanelHost/txtNomServeur");

        // Récupérer infos GUI pour le mettre dans le dico network

        if(!Serveur.Text.Empty())
        {
            myNetwork.Set("info_serveur[nom]",Serveur.Text);
        }

        maxJoueur = (SpinBox) GetNode("res://MenuMultiplayer.tscn/CanvasLayer/PanelHost/txtJoueursMax");
        myNetwork.Set("info_serveur[joueurs_max]", (int) maxJoueur.Value);
        Serveur = (LineEdit) GetNode("res://MenuMultiplayer.tscn/CanvasLayer/PanelHost/txtPortServeur");
        myNetwork.Set("port_utilise", int.Parse(Serveur.Text));

        myNetwork.Call("creer_server");
    }

    public void _on_btRejoindre_pressed()
    {
        // Ajouter les infos du joueur local
        myMenuMultiplayer.Call("set_player_info");

        rejoindre = (LineEdit) GetNode("res://MenuMultiplayer.tscn/CanvasLayer/PanelRejoindre/RejoindrePort");
        var port = int.Parse(rejoindre.Text);
        rejoindre = (LineEdit) GetNode("res://MenuMultiplayer.tscn/CanvasLayer/PanelRejoindre/RejoindreIp");
        var ip = rejoindre.Text;
        myNetwork.Call("rejoindre_serveur", ip, port);
    }
}