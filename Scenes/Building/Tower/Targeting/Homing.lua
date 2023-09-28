function shoot_logic(delta, speed, projectileSpeed)
	local gravity_scale = 0
	if speed < projectileSpeed[2] then
		speed = speed + delta * (projectileSpeed[2] - projectileSpeed[1])
	end
	return speed
end

function hit_logic(area, mass)
	if not area:is_in_group("minions") then
		return area:get_parent().hp
	end
	area:get_parent().hp = area:get_parent().hp - mass
	if area:get_parent().hp <= 0 then
		area:get_parent():queue_free()
	end
	return area:get_parent().hp
end