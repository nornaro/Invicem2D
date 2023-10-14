using Godot;
using System.Collections.Generic;
using static Godot.GD;

public partial class minion : Godot.RigidBody2D
{	
	[Export]
	public Godot.Collections.Dictionary<string, int> Data { get; set; } = new Godot.Collections.Dictionary<string, int>
	{
		["hp"] = 100,
		["def"] = 1000,
		["dodge"] = 0,
	};
	
	private int maxHp;
	private Vector2 initialVelocity;
	private ProgressBar hpBar;
	
	public override void _Ready()
	{
		AddToGroup("minions");
		GravityScale = 0;
		maxHp = Data["hp"];
		hpBar = GetNode<ProgressBar>("hpBar"); // Initialize hpBar here
		GetNode<ProgressBar>("hpBar").MaxValue = Data["hp"];
		GetNode<ProgressBar>("hpBar").Value = Data["hp"];
		initialVelocity = LinearVelocity;
		
	}

	public override void _PhysicsProcess(double delta)
	{
		if (GetTree().GetNodesInGroup("true").Count > 0)
			return;
		var floatDelta = (float)delta;
		if (Rotation != 0)
		{
			if (Rotation > 0 + floatDelta)
				Rotation -= floatDelta;
			if (Rotation < 0 - floatDelta)
				Rotation += floatDelta;
			if (Mathf.Abs(Rotation) < floatDelta)
				Rotation = 0;
		}

		NotifyPropertyListChanged();
	}

	public void Hurt(int mass)
	{
		Data["hp"] -= mass;
		if ((int)Data["hp"] <= 0)
		{
			QueueFree();
			return;
		}
		hpBar.Modulate = new Color(1, Mathf.Pow((float)Data["hp"] / maxHp, 2), 0, 0.75f);
		Print("Hello");
		hpBar.Value = Data["hp"];
		NotifyPropertyListChanged();
		
	}
	private void _on_body_entered(Node body)
	{
		LinearVelocity = initialVelocity;
	}
	private void _on_area_2d_area_entered(Area2D area)
	{
		if (IsInGroup("projectiles"))
			return;
		LinearVelocity = initialVelocity;
	}
}
