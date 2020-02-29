-- МАТЕМАТИКА
local function isNaN( x ) 
	return x ~= x 
end

local sqrt 		= math.sqrt
local deg 		= math.deg
local asin 		= math.asin
local atan2 	= math.atan2
local rad 		= math.rad
local sin 		= math.sin
local cos 		= math.cos

local bone_0 	= {};
local bone_t 	= {};
local bone_f 	= {};

local getPedBonePosition = getPedBonePosition
local setElementPosition = setElementPosition

bone_0[1],bone_t[1],bone_f[1] = 5,nil,6 --head
bone_0[2],bone_t[2],bone_f[2] = 4,5,8 --neck
bone_0[3],bone_t[3],bone_f[3] = 3,nil,31 --spine
bone_0[4],bone_t[4],bone_f[4] = 1,2,3 --pelvis
bone_0[5],bone_t[5],bone_f[5] = 4,32,5 --left clavicle
bone_0[6],bone_t[6],bone_f[6] = 4,22,5 --right clavicle
bone_0[7],bone_t[7],bone_f[7] = 32,33,34 --left shoulder
bone_0[8],bone_t[8],bone_f[8] = 22,23,24 --right shoulder
bone_0[9],bone_t[9],bone_f[9] = 33,34,32 --left elbow
bone_0[10],bone_t[10],bone_f[10] = 23,24,22 --right elbow
bone_0[11],bone_t[11],bone_f[11] = 34,35,36 --left hand
bone_0[12],bone_t[12],bone_f[12] = 24,25,26 --right hand
bone_0[13],bone_t[13],bone_f[13] = 41,42,43 --left hip
bone_0[14],bone_t[14],bone_f[14] = 51,52,53 --right hip
bone_0[15],bone_t[15],bone_f[15] = 42,43,44 --left knee
bone_0[16],bone_t[16],bone_f[16] = 52,53,54 --right knee
bone_0[17],bone_t[17],bone_f[17] = 43,42,44 --left ankle
bone_0[18],bone_t[18],bone_f[18] = 53,52,54 --right angle
bone_0[19],bone_t[19],bone_f[19] = 44,43,42 --left foot
bone_0[20],bone_t[20],bone_f[20] = 54,53,52 --right foot

local function getMatrixFromPoints(x,y,z,x3,y3,z3,x2,y2,z2)
	x3 = x3-x
	y3 = y3-y
	z3 = z3-z
	x2 = x2-x
	y2 = y2-y
	z2 = z2-z
	local x1 = y2*z3-z2*y3
	local y1 = z2*x3-x2*z3
	local z1 = x2*y3-y2*x3
	x2 = y3*z1-z3*y1
	y2 = z3*x1-x3*z1
	z2 = x3*y1-y3*x1
	local len1 = 1/sqrt(x1*x1+y1*y1+z1*z1)
	local len2 = 1/sqrt(x2*x2+y2*y2+z2*z2)
	local len3 = 1/sqrt(x3*x3+y3*y3+z3*z3)
	x1 = x1*len1 y1 = y1*len1 z1 = z1*len1
	x2 = x2*len2 y2 = y2*len2 z2 = z2*len2
	x3 = x3*len3 y3 = y3*len3 z3 = z3*len3
	return x1,y1,z1,x2,y2,z2,x3,y3,z3
end

local function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return deg(asin(z2)),-deg(atan2(vx,vz)),-deg(atan2(x2,y2))
end

local function getMatrixFromEulerAngles(x,y,z)
	x,y,z = rad(x),rad(y),rad(z)
	local sinx,cosx,siny,cosy,sinz,cosz = sin(x), cos(x), sin(y), cos(y), sin(z), cos(z)
	return
		cosy*cosz-siny*sinx*sinz,cosy*sinz+siny*sinx*cosz,-siny*cosx,
		-cosx*sinz,cosx*cosz,sinx,
		siny*cosz+cosy*sinx*sinz,siny*sinz-cosy*sinx*cosz,cosy*cosx
end

local function getBoneMatrix(ped,bone)
	local x,y,z,tx,ty,tz,fx,fy,fz
	x,y,z = getPedBonePosition(ped,bone_0[bone])
	if bone == 1 then
		local x6,y6,z6 = getPedBonePosition(ped,6)
		local x7,y7,z7 = getPedBonePosition(ped,7)
		tx,ty,tz = (x6+x7)*0.5,(y6+y7)*0.5,(z6+z7)*0.5
	elseif bone == 3 then
		local x21,y21,z21 = getPedBonePosition(ped,21)
		local x31,y31,z31 = getPedBonePosition(ped,31)
		tx,ty,tz = (x21+x31)*0.5,(y21+y31)*0.5,(z21+z31)*0.5
	else
		tx,ty,tz = getPedBonePosition(ped,bone_t[bone])
	end
	fx,fy,fz = getPedBonePosition(ped,bone_f[bone])
	local xx,xy,xz,yx,yy,yz,zx,zy,zz = getMatrixFromPoints(x,y,z,tx,ty,tz,fx,fy,fz)
	if bone == 1 or bone == 3 then xx,xy,xz,yx,yy,yz = -yx,-yy,-yz,xx,xy,xz end
	return xx,xy,xz,yx,yy,yz,zx,zy,zz
end

-- ФУНКЦИИ
Attach = {
	Objects 		= {};
	CollectInStream = {}; -- Собранные объекты в стриме
	ObjectGetID		= {}; -- Получение Instance ID из объекта
	
	GetFreeID = function ( self )
		local i = 1
		local size = #self.Objects
		while true do
			local Id = size + i
			if not self.Objects[Id] then
				return Id
			end
		end
	end;
	
	setPosition = function ( self, x, y, z )
		if not x or not y or not z then
			return false
		end
		self.x = x; self.y = y; self.z = z;
		return true
	end;
	
	setRotation = function ( self, x, y, z )
		if not x or not y or not z then
			return false
		end
		self.rx = x; self.rz = y; self.ry = z;
		return true
	end;
	
	detachFromBone = function( self )
		self.ObjectGetID[self.element] = nil;
		self.Objects[self.id] = nil
		self.CollectInStream[self.id] = nil;
		return true
	end;
};

function Attach:attachElementToBone( element, ped, bone, x, y, z, rx, ry, rz )
	if not isElement( element ) or not isElement( ped ) then
		return false
	end
	
	if getElementType( ped ) ~= "ped" and getElementType( ped ) ~= "player" then 
		return false
	end
	
	if getElementType( element ) ~= "object" then 
		return false
	end
	
	if Attach.ObjectGetID[element] then
		return false
	end
	
	if not bone or bone < 1 or bone > 20 then 
		return false 
	end
	
	x, y, z, rx, ry, rz = tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0, tonumber(rx) or 0, tonumber(ry) or 0, tonumber(rz) or 0;
	setElementCollisionsEnabled(element, false);
	
	local Id = Attach:GetFreeID();
	local Instance = setmetatable({
		x = x; rx = rx;
		y = y; ry = ry;
		z = z; rz = rz;
		
		ped = ped; 
		element = element;
		bone = bone;
		id = Id;
	}, { __index = Attach });
	
	Attach.Objects[Id] = Instance;
	Attach.ObjectGetID[element] = Id;

	-- Объект может выдавать false на isElementStreamedIn
	if isElementStreamedIn(element) then
		Attach.CollectInStream[Id] = Id;
	end
	
	return Instance, Id;
end

-- РАБОТА СО СТРИМОМ
local events = { 
	'onClientElementStreamIn';
	'onClientElementStreamOut';
	'onClientElementDestroy';
	'onClientPlayerQuit';
};

local function stream()
	if getElementType(source) == 'object' then
		local this = Attach.Objects[source]
		if this then
			if eventName == events[1] then
				CollectInStream[this.id] = this.id;
			elseif eventName == events[2] then
				local x,y,z = getElementPosition(this.element)
				setElementPosition(x, y, z - 1000.0);
				CollectInStream[this.id] = nil;
			elseif eventName == events[3] then
				this:detachFromBone() -- удаляем вообще все данные из коллекторов
			end
		end
	elseif eventName == events[4] then
		-- Вычищаем
		for Id, Instance in pairs(Attach.Objects) do
			if source == Instance.ped then
				Instance:detachFromBone()
			end
		end
	end
end;

for i, name in ipairs(events) do
	addEventHandler(name, root, stream)
end

-- Обработка
local bHalfFrame = true
local iStepFrame = 1

addEventHandler('onClientPreRender', root, function(timeSlice)
	local iObjectsInStream = #Attach.CollectInStream
	local iHalfCount = math.ceil(iObjectsInStream / DIVISION_ARRAY)
	-- обновление позиций только в половине кадров
	if bHalfFrame then
		for i = iStepFrame, iStepFrame + iHalfCount do
			local Id = Attach.CollectInStream[i]
			local Instance = Attach.Objects[Id]
			if Instance then
				local bOnScreen = isElementOnScreen(Instance.ped)
				if bOnScreen then
					local x,y,z = getPedBonePosition(Instance.ped, bone_0[Instance.bone])
					local xx,xy,xz,yx,yy,yz,zx,zy,zz = getBoneMatrix(Instance.ped, Instance.bone)
					
					local offrx,offry,offrz = Instance.rx, Instance.ry, Instance.rz
					
					local objx = x+Instance.x*xx+Instance.y*yx+Instance.z*zx
					local objy = y+Instance.x*xy+Instance.y*yy+Instance.z*zy
					local objz = z+Instance.x*xz+Instance.y*yz+Instance.z*zz
					
					local rxx, rxy, rxz, ryx, ryy, ryz, rzx, rzy, rzz = getMatrixFromEulerAngles(offrx,offry,offrz)

					local txx = rxx*xx+rxy*yx+rxz*zx
					local txy = rxx*xy+rxy*yy+rxz*zy
					local txz = rxx*xz+rxy*yz+rxz*zz
					local tyx = ryx*xx+ryy*yx+ryz*zx
					local tyy = ryx*xy+ryy*yy+ryz*zy
					local tyz = ryx*xz+ryy*yz+ryz*zz
					local tzx = rzx*xx+rzy*yx+rzz*zx
					local tzy = rzx*xy+rzy*yy+rzz*zy
					local tzz = rzx*xz+rzy*yz+rzz*zz

					offrx, offry, offrz = getEulerAnglesFromMatrix(txx, txy, txz, tyx, tyy, tyz, tzx, tzy, tzz)

					if isNaN( objx ) or isNaN( objy ) or isNaN( objz ) then
						setElementPosition(Instance.element, x, y, z)
					else
						setElementPosition(Instance.element, objx, objy, objz)
					end

					if not isNaN( offrx ) and not isNaN( offry ) and not isNaN( offrz ) then
						setElementRotation(Instance.element, offrx, offry, offrz, 'ZXY')
					else
						setElementPosition(Instance.element, getElementPosition(Instance.ped))
					end
				else
					local x,y,z = getElementPosition(Instance.ped)
					setElementPosition(Instance.element, x, y, z - 1000.0)
				end
			end
		end
		-- Сдвиг шагов
		iStepFrame = iStepFrame + iHalfCount
		if iStepFrame >= iObjectsInStream then
			iStepFrame = 1
		end
	end
	
	if ENABLED_CONTINUE_FRAME then
		bHalfFrame = not bHalfFrame
	end
end )

-- Остальные экспортны и события
-- Задержки таймерами нужны для того чтобы объект попал в стриминг

addEventHandler('onClientResourceStop', resourceRoot, function()
	for Id, Instance in pairs(Attach.Objects) do
		Instance:detachFromBone()
	end
end );

addEvent('Attach::m_ElementToBone', true);
addEventHandler('Attach::m_ElementToBone', resourceRoot, function( element, ped, bone, x, y, z, rx, ry, rz )
	setTimer(function()
		Attach:attachElementToBone( element, ped, bone, x, y, z, rx, ry, rz )
	end, 80, 0)
end )

addEvent('Attach::m_ElementDetachFromBone', true);
addEventHandler('Attach::m_ElementDetachFromBone', resourceRoot, function( element )
	setTimer(function()
		local Id = Attach.ObjectGetID[element]
		if Id then
			local Instance = Attach.Objects[Id]
			Instance:detachFromBone()
		end
	end, 120, 0)
end )

addEvent('Attach::m_ElementSetRotation', true);
addEventHandler('Attach::m_ElementSetRotation', resourceRoot, function( element, x, y, z )
	setTimer(function()
		local Id = Attach.ObjectGetID[element]
		if Id then
			local Instance = Attach.Objects[Id]
			Instance:setRotation( x, y, z );
		end
	end, 120, 0)
end )

addEvent('Attach::m_ElementSetPosition', true);
addEventHandler('Attach::m_ElementSetPosition', resourceRoot, function( element, x, y, z )
	setTimer(function()
		local Id = Attach.ObjectGetID[element]
		if Id then
			local Instance = Attach.Objects[Id]
			Instance:setPosition( x, y, z );
		end
	end, 120, 0)
end )

-- Proxy
function AttachElementToBone( element, ped, bone, x, y, z, rx, ry, rz )
	triggerEvent( 'Attach::m_ElementToBone', resourceRoot, element, ped, bone, x, y, z, rx, ry, rz )
end

function DetachElementFromBone( element, ped, bone, x, y, z, rx, ry, rz )
	triggerEvent( 'Attach::m_ElementDetachFromBone', resourceRoot, element, ped, bone, x, y, z, rx, ry, rz )
end

function AttachElementSetRotation( element, x, y, z )
	triggerEvent( 'Attach::m_ElementSetRotation', resourceRoot, element, x, y, z )
end

function AttachElementSetPosition( element, x, y, z )
	triggerEvent( 'Attach::m_ElementSetPosition', resourceRoot, element, x, y, z )
end