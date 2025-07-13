-- otimização extrema para fps (modo batata refinado)

local players      = game:GetService("Players")
local lighting     = game:GetService("Lighting")
local runService   = game:GetService("RunService")
local workspace    = game:GetService("Workspace")

-- configurações iniciais de iluminação e render
lighting.GlobalShadows     = false
lighting.FogEnd            = math.huge
lighting.Brightness        = 0
lighting.OutdoorAmbient    = Color3.new(1,1,1)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- função para limpar efeitos visuais
local function clearVisuals(obj)
    for _, child in ipairs(obj:GetDescendants()) do
        if child:IsA("ParticleEmitter") 
        or child:IsA("Trail") 
        or child:IsA("Smoke") 
        or child:IsA("Fire") 
        or child:IsA("Explosion") then
            child:Destroy()
        elseif child:IsA("Decal") 
        or child:IsA("Texture") then
            child.Transparency = 1
        elseif child:IsA("MeshPart") 
        or child:IsA("Part") 
        or child:IsA("UnionOperation") then
            child.Material    = Enum.Material.SmoothPlastic
            child.Reflectance = 0
            child.CastShadow  = false
        end
    end
end

-- limpa efeitos de workspace e personagens inicialmente
clearVisuals(workspace)
for _, plr in ipairs(players:GetPlayers()) do
    if plr.Character then
        clearVisuals(plr.Character)
    end
end

-- remove sons e define volume zero
for _, s in ipairs(workspace:GetDescendants()) do
    if s:IsA("Sound") then
        s:Stop()
        s.Volume = 0
    end
end

-- atualiza periodicamente para cobrir spawns futuros
runService.RenderStepped:Connect(function()
    -- mantém qualidade baixa
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    -- remove sombras dinâmicas
    lighting.GlobalShadows = false

    -- limpa novos objetos adicionados ao workspace
    clearVisuals(workspace)

    -- limpa acessórios e texturas de personagens (caso apareçam depois)
    for _, plr in ipairs(players:GetPlayers()) do
        local char = plr.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("Accessory") 
                or part:IsA("Clothing") 
                or part:IsA("ShirtGraphic") 
                or part:IsA("Decal") then
                    part:Destroy()
                elseif part:IsA("Part") 
                or part:IsA("MeshPart") then
                    part.Material = Enum.Material.SmoothPlastic
                    part.Color    = Color3.new(1,1,1)
                end
            end
        end
    end
end)
