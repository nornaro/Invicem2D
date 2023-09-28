using Godot;
using System.Collections.Generic;

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

	public override void _Ready()
	{
		AddToGroup("minions");
		GravityScale = 0;
		maxHp = Data["hp"];
		GetNode<ProgressBar>("hpBar").MaxValue = Data["hp"];
		GetNode<ProgressBar>("hpBar").Value = Data["hp"];
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

	public void Hurt()
	{
		var hpBar = GetNode<ProgressBar>("hpBar");
		hpBar.Modulate = new Color(1, Mathf.Pow((float)Data["hp"] / maxHp, 2), 0, 0.75f);
		hpBar.Value = Data["hp"];
		NotifyPropertyListChanged();
	}
}
