function AttachElementToBone( element, ped, bone, x, y, z, rx, ry, rz )
	triggerClientEvent( ped, 'Attach::m_ElementToBone', resourceRoot, element, ped, bone, x, y, z, rx, ry, rz )
end

function DetachElementFromBone( element, ped, bone, x, y, z, rx, ry, rz )
	triggerClientEvent( ped, 'Attach::m_ElementDetachFromBone', resourceRoot, element, ped, bone, x, y, z, rx, ry, rz )
end

function AttachElementSetRotation( element, ped, x, y, z )
	triggerClientEvent( ped, 'Attach::m_ElementSetRotation', resourceRoot, element, x, y, z )
end

function AttachElementSetPosition( element, ped, x, y, z )
	triggerClientEvent( ped, 'Attach::m_ElementSetPosition', resourceRoot, element, x, y, z )
end