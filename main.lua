-- Módulos e dependências
suit = require 'biblioteca/suit'
opcao = require 'fuction/opcao'
button = require 'fuction/button'
sons = require 'fuction/sons'
anim8 = require "biblioteca/anim8"
sti = require "biblioteca/sti"
camera = require "biblioteca/camera"
wf = require 'biblioteca/windfield'
local LG = love.graphics
local LK = love.keyboard
local gameMap = sti('mapa/fase 1/fase1.lua')
local direcaoAtual = 1       -- 1 para direita, -1 para esquerda
local cooldownTiro = 0       -- Tempo restante para o próximo tiro
local tempoCooldownTiro = 0.5
local tempoBonusCooldown = 0 -- Tempo restante para o bônus de cooldown
local tempoTiroMicrozila = 2.5
local intervaloTiroMicrozila = 2.5
-- Configurações e variáveis do jogo
polyline2 = {
  { x = 0,       y = 0 },
  { x = 16.25,   y = 0.25 },
  { x = 16.25,   y = 16 },
  { x = 416.5,   y = 15.75 },
  { x = 416.25,  y = 0 },
  { x = 432.75,  y = -0.25 },
  { x = 432.25,  y = -16 },
  { x = 480.75,  y = -16.25 },
  { x = 480.75,  y = -32 },
  { x = 624.75,  y = -32.5 },
  { x = 624.75,  y = -48.25 },
  { x = 688.5,   y = -48.5 },
  { x = 688.25,  y = -64.75 },
  { x = 736,     y = -65.5 },
  { x = 736,     y = -80.25 },
  { x = 784.25,  y = -80.25 },
  { x = 784.25,  y = -64 },
  { x = 1104.5,  y = -64.5 },
  { x = 1104.75, y = -48.25 },
  { x = 1361,    y = -48 },
  { x = 1361,    y = -31.5 },
  { x = 1537,    y = -32 },
  { x = 1537.25, y = -16.75 },
  { x = 1568.5,  y = -16.25 },
  { x = 1569,    y = 15.5 },
  { x = 1584.5,  y = 15.25 },
  { x = 2032.25, y = 15.75 },
  { x = 2032.5,  y = -0.25 },
  { x = 2129.25, y = -0.75 },
  { x = 2129,    y = -16.25 },
  { x = 2145.25, y = -16.25 },
  { x = 2145,    y = -32 },
  { x = 2160.5,  y = -32.25 },
  { x = 2160.75, y = -17 },
  { x = 2177,    y = -17 },
  { x = 2177,    y = -0.75 },
  { x = 2512.25, y = -0.25 },
  { x = 2512.25, y = 16 },
  { x = 2944.25, y = 15 },
  { x = 2944.25, y = -0.75 },
  { x = 2992.75, y = -1 },
  { x = 2992.75, y = -16.75 },
  { x = 3008.75, y = -16.5 },
  { x = 3008.75, y = -32.25 },
  { x = 3024.75, y = -32.5 },
  { x = 3024.75, y = -16.5 },
  { x = 3040.5,  y = -16.5 },
  { x = 3040.75, y = -0.75 },
  { x = 3472.5,  y = -0.25 },
  { x = 3472,    y = -16.5 },
  { x = 3616,    y = -16.75 },
  { x = 3615.75, y = -32.75 },
  { x = 3936.25, y = -32.5 },
  { x = 3936.5,  y = -47.75 },
  { x = 4337.25, y = -48 },
  { x = 4337.75, y = -0.5 },
  { x = 4385,    y = -0.25 },
  { x = 4385.25, y = 47.5 },
  { x = 4401,    y = 47.25 },
  { x = 4401.5,  y = 63.75 },
  { x = 4800.25, y = 63.25 }
}
polyline = {
  { x = 0,    y = 0 },
  { x = 704,  y = 0 },
  { x = 704,  y = -16 },
  { x = 720,  y = -16 },
  { x = 720,  y = -32 },
  { x = 816,  y = -32 },
  { x = 816,  y = -16 },
  { x = 832,  y = -16 },
  { x = 832,  y = 0 },
  { x = 1536, y = 0 },
  { x = 1536, y = 16 },
  { x = 1552, y = 16 },
  { x = 1552, y = 32 },
  { x = 2016, y = 32 },
  { x = 2016, y = 16 },
  { x = 2032, y = 16 },
  { x = 2032, y = 0 },
  { x = 4576, y = 0 },
  { x = 4576, y = 16 },
  { x = 4608, y = 16 },
  { x = 4608, y = 32 },
  { x = 4640, y = 32 },
  { x = 4640, y = 48 },
  { x = 4672, y = 48 },
  { x = 4672, y = 64 },
  { x = 4704, y = 64 },
  { x = 4704, y = 80 },
  { x = 4736, y = 80 },
  { x = 4736, y = 96 },
  { x = 4800, y = 96 }
}
local jogo = {
  sons = { value = 60, max = 100 },
  brilho = { value = 80, max = 100 },
  telaCheia = false,
  larguraBotaoBase = 300,
  alturaBotaoBase = 30,
  larguraBotao = 300,
  alturaBotao = 30,
  indice = 1,
  tempoAnimacao = 0.2,
  larguraTela = LG.getWidth(),
  alturaTela = LG.getHeight(),
  posicaoBotaoX = 0,
  posicaoBotaoY = 0,
  escalaX = 1,
  escalaY = 1,
  imagemFundo = LG.newVideo('sprits/fundo.ogv'),
  animacaoFundo = nil,
  fonte = nil,
  exibirMensagem1 = false,
  exibirMensagem2 = false,
  exibirBotoes = true,
  mapaLargura = 9000,
  mapaAltura = gameMap.height * gameMap.tileheight,
  mapLargura = 1,
  mapAltura = 1,
  escala = 1,
  escalaBloco = 0,
  estado = "cutscene",
  chuva = nil,
  imagemChuva = LG.newImage("Sprit shet/gota.png"),
  soma = 330,
  pontuacao = 0,
  cutscene = nil,
  movimento = 0,
  estadoAnterior = nil,
  chef = true,
}
local player = {
  x = 345,
  y = 134,
  speed = 200,
  spLeft = LG.newImage('Sprit shet/panda andando.png'),
  spRiht = LG.newImage('Sprit shet/panda andando right.png'),
  spAtira = LG.newImage('Sprit shet/panda atirando.png'),
  spAtira1 = LG.newImage('Sprit shet/panda atirando right.png'),
  grid = nil,
  grid1 = nil,
  anim = nil,
  lado = LG.newImage('Sprit shet/panda andando.png'),
  collider = nil,
  jumpCooldown = 0, -- Tempo de recarga para o próximo pulo
  vida = 200,
  largura = 30,
  altura = 70,
  danoTimer = 0, -- Tempo em que o jogador ficará vermelho
  coracao = LG.newImage('Sprit shet/heart.png'),
  coracaoVazio = LG.newImage('Sprit shet/heart-empty.png')
}

local inimigos = {}
local tiros = {}
local raios = {}

-- Função para criar inimigos
local function criarInimigo(x, y, tipo, vida, speed)
  local inimigo = {
    x = x,
    y = y,
    speed = speed or 100,
    tipo = tipo,
    vida = vida or 100,
    lado = "left",
    collider = world:newRectangleCollider(x, y, 60, 70),
    spIS = LG.newImage('Sprit shet/inimigo Sushi.png'),
    grid = nil,
    anim = nil,
    limiteEsquerdo = x - 80,
    limiteDireito = x + 200,
    danoTimer = 0 -- Tempo em que o inimigo ficará vermelho
  }
  inimigo.collider:setType("dynamic")
  inimigo.collider:setFixedRotation(true)
  inimigo.collider:setFriction(0) -- Reduz o atrito para evitar travamentos
  inimigo.collider:setMass(1)
  inimigo.grid = anim8.newGrid(64, 64, inimigo.spIS:getWidth(), inimigo.spIS:getHeight())
  inimigo.anim = anim8.newAnimation(inimigo.grid('1-6', 1), 0.2)
  table.insert(inimigos, inimigo)
  inimigo.spIni = inimigo.spIS
end
local function CarregarChuva()
  jogo.imagemChuva:setFilter("nearest", "nearest")
  jogo.chuva = LG.newParticleSystem(jogo.imagemChuva, 1000)  -- Máximo de 1000 partículas
  jogo.chuva:setParticleLifetime(0.95)                       -- Tempo de vida das partículas (1 a 2 segundos)
  jogo.chuva:setEmissionRate(100)                            -- Taxa de emissão (partículas por segundo)
  jogo.chuva:setSizeVariation(0.5)                           -- Variação no tamanho das partículas
  jogo.chuva:setLinearAcceleration(-10, 300, 10, 500)        -- Velocidade vertical (simula a gravidade)
  jogo.chuva:setEmissionArea("uniform", jogo.larguraTela, 0) -- Espalha as partículas horizontalmente
end
local function criarTiro(x, y, direcao)
  local tiro = {
    x = x,
    y = y,
    speed = 500,       -- Velocidade do tiro
    direcao = direcao, -- Direção do tiro (1 para direita, -1 para esquerda)
    largura = 10,
    altura = 3
  }
  if direcao == 1 then
    tiro.x = tiro.x + player.largura -- Ajusta a posição do tiro para a direita
  else
    tiro.x = tiro.x - player.largura -- Ajusta a posição do tiro para a esquerda
  end
  table.insert(tiros, tiro)
end
local function criarRaio(x, y, direcao)
  local raio = {
    x = x,
    y = y,
    speed = 100,
    direcao = direcao, -- 1 para direita, -1 para esquerda
    largura = 30,
    altura = 4,
    tempo = 1 -- tempo de vida do raio
  }
  table.insert(raios, raio)
end
local function reiniciarJogo(estado)
  -- Redefine as variáveis do jogador
  player.x = 345
  player.y = 134
  player.vida = 100
  player.danoTimer = 0
  player.collider:setPosition(400, 250)

  -- Remove todos os inimigos e recria os iniciais
  for _, inimigo in ipairs(inimigos) do
    if inimigo.collider then
      inimigo.collider:destroy()
    end
  end
  carregarInimigos(8)
  jogo.pontuacao = 0 -- Reseta a pontuação
  -- Remove todos os tiros
  tiros = {}

  -- Reseta outras variáveis do jogo, se necessário
  jogo.exibirMensagem1 = true
  jogo.estado = estado
end
function carregarInimigos(num)
  tempoTiroMicrozila = intervaloTiroMicrozila -- reinicia o timer do microzila
  inimigos = {}
  local inimigosIniciais = num
  local posX = 900
  local posY = 230
  local limite = 900
  math.randomseed(os.time())
  for i = 0, inimigosIniciais do
    if i >= 2 and i <= 3 then
      criarInimigo(posX, posY, "picles")
    elseif i == 5 then
      criarInimigo(posX, posY, "master")
    elseif i == 6 then
      criarInimigo(8300, 383, "microzila", 200, 50)
    else
      criarInimigo(posX, posY, "normal")
    end
    posX = math.random(posX + 100, limite)
    posX = i * 900
    limite = (i + 1) * 900
  end

  -- Cria o microzila apenas uma vez, no final do mapa, nos estados corretos
end

local tutorialImg = LG.newImage("Sprit shet/tutorial.png")

function desenharTutorial()
  local scale = 2 -- ajuste para 0.7 ou outro valor se necessário
  local imgW, imgH = tutorialImg:getWidth(), tutorialImg:getHeight()
  local x = jogo.larguraTela - imgW * scale - 10
  local y = jogo.alturaTela - imgH * scale - 10
  LG.setColor(1, 1, 1, 0.95)
  LG.draw(tutorialImg, x, y, 0, scale, scale)
  LG.setColor(1, 1, 1, 1)
end

local function desenharMiniMapa()
  local miniMapaLargura = 200 -- Largura do mini mapa
  local miniMapaAltura = 50   -- Altura do mini mapa
  local escalaMiniMapaX = miniMapaLargura / jogo.mapaLargura
  local escalaMiniMapaY = miniMapaAltura / jogo.mapaAltura

  -- Desenhar o fundo do mini mapa
  LG.setColor(0, 0, 0, 0.5) -- Fundo preto com transparência
  LG.rectangle("fill", jogo.larguraTela - miniMapaLargura - 10, 40, miniMapaLargura, miniMapaAltura)

  -- Desenhar o jogador no mini mapa
  LG.setColor(0, 1, 0) -- Verde para o jogador
  LG.rectangle(
    "fill",
    jogo.larguraTela - miniMapaLargura - 10 + player.x * escalaMiniMapaX,
    10 + player.y * escalaMiniMapaY,
    5, -- Largura do jogador no mini mapa
    5  -- Altura do jogador no mini mapa
  )

  -- Encontrar o inimigo mais próximo
  local inimigoMaisProximo = nil
  local menorDistancia = math.huge -- Inicializa com um valor muito alto

  for _, inimigo in ipairs(inimigos) do
    local distancia = math.sqrt((inimigo.x - player.x) ^ 2 + (inimigo.y - player.y) ^ 2)
    if distancia < menorDistancia then
      menorDistancia = distancia
      inimigoMaisProximo = inimigo
    end
  end

  -- Desenhar o inimigo mais próximo no mini mapa
  if inimigoMaisProximo then
    LG.setColor(1, 0, 0) -- Vermelho para o inimigo mais próximo
    LG.rectangle(
      "fill",
      jogo.larguraTela - miniMapaLargura - 10 + inimigoMaisProximo.x * escalaMiniMapaX,
      10 + inimigoMaisProximo.y * escalaMiniMapaY,
      5, -- Largura do inimigo no mini mapa
      5  -- Altura do inimigo no mini mapa
    )
  end


  -- Reseta a cor para o padrão
  LG.setColor(1, 1, 1)
end
local function atualizarTiros(dt)
  for i = #tiros, 1, -1 do
    local tiro = tiros[i]
    tiro.x = tiro.x + (tiro.speed * tiro.direcao * dt)
    if jogo.pontuacao == 40 and tempoBonusCooldown <= 0 then
      tempoCooldownTiro = 0.2  -- Reduz o cooldown
      tempoBonusCooldown = 0.1 -- Define o bônus para durar 5 segundos
    end
    -- Verifica colisão com inimigos
    for j = #inimigos, 1, -1 do
      local inimigo = inimigos[j]

      -- Ajuste do ponto de colisão (offsetY)
      -- Ajusta a posição do tiro para o ponto de colisão correto

      -- Verifica se o tiro colide com o inimigo (detecção de colisão de retângulos, igual ao player)
      if tiro.x < inimigo.x + 60 / 2 and
          tiro.x + tiro.largura > inimigo.x - 60 / 2 and
          tiro.y < inimigo.y + 70 / 2 and
          tiro.y + tiro.altura > inimigo.y - 70 / 2 then
        -- Reduz a vida do inimigo
        inimigo.vida = inimigo.vida - 20
        inimigo.danoTimer = 0.2
        if inimigo.vida <= 0 then
          inimigo.collider:destroy()
          table.remove(inimigos, j)
          jogo.pontuacao = jogo.pontuacao + 10 -- Adiciona pontos ao jogador
        end

        -- Remove o tiro
        table.remove(tiros, i)
        break
      end
    end

    -- Remove o tiro se ele sair da tela
    if tiro.x < 0 or tiro.x > jogo.mapaLargura then
      table.remove(tiros, i)
    end
  end
end
local function atualizarRaios(dt)
  for i = #raios, 1, -1 do
    local raio = raios[i]
    raio.x = raio.x + (raio.speed * raio.direcao * dt)
    raio.tempo = raio.tempo - dt
    -- Colisão com o player
    if player.x < raio.x + raio.largura and player.x + player.largura > raio.x and
        player.y < raio.y + raio.altura and player.y + player.altura > raio.y then
      player.vida = player.vida - 30
      player.danoTimer = 0.2
      table.remove(raios, i)
    elseif raio.x < 0 or raio.x > jogo.mapaLargura or raio.tempo <= 0 then
      table.remove(raios, i)
    end
  end
end

local function desenharTiros()
  LG.setDefaultFilter("nearest", "nearest")
  for _, tiro in ipairs(tiros) do
    LG.setColor(1, 0.8, 0.2) -- Cor vermelha para os tiros
    LG.rectangle("fill", tiro.x, tiro.y, tiro.largura, tiro.altura)
  end
  LG.setColor(1, 1, 1) -- Reseta a cor para o padrão
end

local function desenharRaios()
  for _, raio in ipairs(raios) do
    LG.setColor(1, 1, 0.2, 0.8)
    LG.rectangle("fill", raio.x, raio.y, raio.largura, raio.altura)
    LG.setColor(1, 1, 1)
  end
end

local function atualizarInimigos(dt)
  local cameraLeft = cam.x - jogo.larguraTela / 2
  local cameraRight = cam.x + jogo.larguraTela / 2
  for _, inimigo in ipairs(inimigos) do
    inimigo.x, inimigo.y = inimigo.collider:getPosition()
    if inimigo.danoTimer > 0 then
      inimigo.danoTimer = inimigo.danoTimer - dt
    end
    local velX, velY = inimigo.collider:getLinearVelocity()
    -- Só persegue se estiver na área da câmera
    if inimigo.x > cameraLeft and inimigo.x < cameraRight then
      local dx = player.x - inimigo.x
      local distancia = math.abs(dx)
      if distancia > 5 then
        local dirX = dx / distancia
        local velocidade = inimigo.speed
        inimigo.collider:setLinearVelocity(dirX * velocidade, velY)
        if dirX < 0 then
          inimigo.lado = "left"
        else
          inimigo.lado = "right"
        end
      else
        inimigo.collider:setLinearVelocity(0, velY)
      end
    else
      inimigo.collider:setLinearVelocity(0, velY)
    end
    -- Microzila atira
    if inimigo.tipo == "microzila" then
      tempoTiroMicrozila = tempoTiroMicrozila - dt
      if tempoTiroMicrozila <= 0 then
        local dir = (player.x > inimigo.x) and 1 or -1
        criarRaio(inimigo.x + dir * 40, inimigo.y, dir)
        tempoTiroMicrozila = intervaloTiroMicrozila
      end
    end
    if player.collider:getX() - player.largura < inimigo.x + 60 / 2 and
        player.collider:getX() + player.largura > inimigo.x - 60 / 2 and
        player.collider:getY() - player.altura / 2 < inimigo.y + 60 / 2 and
        player.collider:getY() + player.altura / 2 > inimigo.y - 60 / 2 then
      if player.danoTimer <= 0 then
        player.vida = player.vida - 10
        player.danoTimer = 0.5
        player.collider:applyLinearImpulse(0, -50)
      end
    end

    inimigo.anim:update(dt)
  end
  -- Após atualizar todos os inimigos, verifica se ainda existe microzila viva
  local microzilaVivo = false
  for _, inimigo in ipairs(inimigos) do
    if inimigo.tipo == "microzila" then
      microzilaVivo = true
      break
    end
  end
  if not microzilaVivo and jogo.estado == "jogando2" then
    jogo.estado = "vitoria"
    jogo.exibirMensagem1 = true
  end
end
local function desenharVida()
  local coracaoLargura = player.coracao and player.coracao:getWidth() * 1.5 or 24
  LG.setColor(1, 1, 1)
  LG.print("Pontuação: " .. jogo.pontuacao, jogo.larguraTela - 200, 10)

  for i = 1, 3 do
    local coracaoX = 10 + (i - 1) * (coracaoLargura + 5)

    if player.coracao then
      LG.draw(player.coracao, 10 + coracaoX, 10, 0, 1.5, 1.5)
      player.coracao:setFilter("nearest", "nearest")
    else
      print("[ERRO] player.coracao não carregado!")
    end
    if player.coracaoVazio then
      player.coracaoVazio:setFilter("nearest", "nearest")
    else
      print("[ERRO] player.coracaoVazio não carregado!")
    end
    if player.vida <= 75 then
      if i == 3 and player.coracaoVazio then
        LG.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
    if player.vida <= 50 then
      if i == 2 and player.coracaoVazio then
        LG.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
    if player.vida <= 25 then
      if i == 1 and player.coracaoVazio then
        LG.draw(player.coracaoVazio, 10 + coracaoX, 10, 0, 1.5, 1.5)
      end
    end
  end
  if (jogo.estado == "jogando" or jogo.estado == "cutscene") and jogo.chuva then
    LG.draw(jogo.chuva, jogo.larguraTela / 2, 0, 0, 1.5, 1.5)
  end
end

-- Função para desenhar os inimigos
local function desenharInimigos()
  for _, inimigo in ipairs(inimigos) do
    -- Inicializa sprite e animação apenas uma vez por tipo
    if not inimigo.spriteSet then
      if inimigo.tipo == "picles" then
        inimigo.speed = 110
        inimigo.spIS = LG.newImage('Sprit shet/inimigo picles.png')
      elseif inimigo.tipo == "master" then
        inimigo.speed = 105
        inimigo.spIS = LG.newImage('Sprit shet/inimigo sushi master.png')
      elseif inimigo.tipo == "microzila" then
        inimigo.speed = 120
        inimigo.spIS = LG.newImage('Sprit shet/microondas.png')
        inimigo.vidaMax = inimigo.vida or 300
      end
      inimigo.spIS:setFilter("nearest", "nearest")
      inimigo.grid = anim8.newGrid(64, 64, inimigo.spIS:getWidth(), inimigo.spIS:getHeight())
      inimigo.anim = anim8.newAnimation(inimigo.grid('1-6', 1), 0.2)
      inimigo.spriteSet = true
    end
    if inimigo.danoTimer > 0 then
      LG.setColor(1, 0, 0, 0.8) -- Vermelho
    else
      LG.setColor(1, 1, 1)      -- Branco (cor normal)
    end
    local escalaX = inimigo.lado == "left" and -1.8 or 1.8
    inimigo.anim:draw(inimigo.spIS, inimigo.x, inimigo.y, nil, escalaX, 1.8, 32, 32)
    -- Barra de vida proporcional à vida máxima
    local barraLargura = 50
    local barraAltura = 5
    local vidaMax = inimigo.vidaMax or 100
    local vidaPercentual = inimigo.vida / vidaMax
    LG.setColor(0, 0, 0)
    LG.rectangle("fill", inimigo.x - barraLargura / 2, inimigo.y - 40, barraLargura, barraAltura)
    if vidaPercentual < 0.4 then
      LG.setColor(1, 0, 0)
    elseif vidaPercentual >= 0.4 and vidaPercentual <= 0.6 then
      LG.setColor(1, 0.5, 0)
    else
      LG.setColor(0, 1, 0)
    end
    LG.rectangle("fill", inimigo.x - barraLargura / 2, inimigo.y - 40, barraLargura * vidaPercentual, barraAltura)
  end
  -- Debug: printa todos os tipos de inimigos na tela

  LG.setColor(1, 1, 1)
end
local Walls = {} -- Declare Walls fora da função para armazenar os colliders

local function carregarLinhas()
  -- Limpa os colliders existentes em Walls
  for _, wall in ipairs(Walls) do
    wall:destroy() -- Destroi os colliders antigos
  end
  Walls = {}       -- Reinicia a tabela Walls

  -- Cria novos colliders com base na polyline

  for i = 1, #polyline - 1 do
    local p1 = polyline[i]
    local p2 = polyline[i + 1]
    local scaled_x1 = p1.x * jogo.escalaBloco
    local scaled_y1 = p1.y * jogo.escalaBloco
    local scaled_x2 = p2.x * jogo.escalaBloco
    local scaled_y2 = p2.y * jogo.escalaBloco
    local wall = world:newLineCollider(scaled_x1, scaled_y1 + jogo.soma, scaled_x2, scaled_y2 + jogo.soma)
    wall:setType('static')
    table.insert(Walls, wall)
  end
end
local function carregarLinhas2()
  -- Limpa os colliders existentes em Walls
  for _, wall in ipairs(Walls) do
    wall:destroy() -- Destroi os colliders antigos
  end
  Walls = {}       -- Reinicia a tabela Walls

  -- Cria novos colliders com base na polyline

  for i = 1, #polyline2 - 1 do
    local p1 = polyline2[i]
    local p2 = polyline2[i + 1]
    local scaled_x1 = p1.x * jogo.escalaBloco
    local scaled_y1 = p1.y * jogo.escalaBloco
    local scaled_x2 = p2.x * jogo.escalaBloco
    local scaled_y2 = p2.y * jogo.escalaBloco
    local wall = world:newLineCollider(scaled_x1, scaled_y1 + jogo.soma - 30, scaled_x2, scaled_y2 + jogo.soma - 30)
    wall:setType('static')
    table.insert(Walls, wall)
  end
end
local function desenharPlayer()
  local pontuacao = 40
  if player.danoTimer > 0 then
    LG.setColor(1, 0, 0) -- Vermelho
  elseif jogo.pontuacao == pontuacao then
    player.speed = 200
    LG.setColor(0.1, 0.5, 1, 0.9) -- Azul
    sons(jogo.sons, false, "up")
    pontuacao = pontuacao + 40
  elseif not jogo.exibirMensagem1 then
    sons(jogo.sons, false, "para")
    LG.setColor(1, 1, 1) -- Branco (cor normal)
  end

  player.anim:draw(player.lado, player.x - 57, player.y - 80, nil, 1.8)
  LG.setColor(1, 1, 1) -- Reseta a cor para o padrão
end

local function resetarEixoY()
  -- Reseta o eixo Y do jogador
  local posicaoInicialYJogador = 250 -- Defina a posição inicial no eixo Y
  player.collider:setY(posicaoInicialYJogador)
  player.y = posicaoInicialYJogador

  -- Reseta o eixo Y dos inimigos
  local posicaoInicialYInimigos = 237 -- Defina a posição inicial no eixo Y para os inimigos
  for _, inimigo in ipairs(inimigos) do
    inimigo.collider:setY(posicaoInicialYInimigos)
    inimigo.y = posicaoInicialYInimigos
  end
end
local function resetarEixoY2()
  -- Reseta o eixo Y do jogador
  local posicaoInicialYJogador = 290 -- Defina a posição inicial no eixo Y
  player.collider:setY(posicaoInicialYJogador)
  player.y = posicaoInicialYJogador
  player.collider:setX(318)
  player.x = 318
  -- Reseta o eixo Y dos inimigos
  local posicaoInicialYInimigos = 237 -- Defina a posição inicial no eixo Y para os inimigos
  for _, inimigo in ipairs(inimigos) do
    inimigo.collider:setY(posicaoInicialYInimigos)
    inimigo.y = posicaoInicialYInimigos
  end
end
local function atualizarTamanhoTela()
  jogo.larguraTela = LG.getWidth()
  jogo.alturaTela = LG.getHeight()
  jogo.posicaoBotaoX = (jogo.larguraTela - jogo.larguraBotao) / 2
  jogo.posicaoBotaoY = (jogo.alturaTela - jogo.alturaBotao) / 2
  jogo.escalaX = jogo.larguraTela / jogo.imagemFundo:getWidth()
  jogo.escalaY = jogo.alturaTela / jogo.imagemFundo:getHeight()
  jogo.mapLargura = jogo.larguraTela / jogo.mapaLargura
  jogo.mapAltura = jogo.alturaTela / jogo.mapaAltura
  if jogo.telaCheia then
    jogo.escalaBloco = 2.4
    jogo.soma = 420
  elseif not jogo.telaCheia then
    jogo.escalaBloco = 1.875
    jogo.soma = 330
  end
  if jogo.telaCheia ~= jogo.telaCheiaAnterior then
    resetarEixoY()
    jogo.telaCheiaAnterior = jogo.telaCheia -- Atualiza o estado anterior
  end
  if jogo.estado == "jogando" or jogo.estado == "cutscene" then
    carregarLinhas()
  end
end


-- Função de carregamento do jogo
function love.load()
  if jogo.estado == "jogando" or jogo.estado == "cutscene" then
    CarregarChuva()
  end
  jogo.imagemFundo:play()
  jogo.imagemFundo:setFilter("linear", "linear")

  world = wf.newWorld(0, 500, true)
  cam = camera()
  sons(jogo.sons, true, true)
  player.animation = {}
  player.grid = anim8.newGrid(64, 64, player.spLeft:getWidth(), player.spLeft:getHeight())
  player.animation.left = anim8.newAnimation(player.grid('2-7', 1), 0.2)
  player.grid1 = anim8.newGrid(64, 64, player.spRiht:getWidth(), player.spRiht:getHeight())
  player.animation.right = anim8.newAnimation(player.grid1('2-7', 1), 0.2)
  player.grid2 = anim8.newGrid(64, 64, player.spAtira:getWidth(), player.spAtira:getHeight())
  player.animation.atira = anim8.newAnimation(player.grid2('1-6', 1), 0.1)
  player.grid3 = anim8.newGrid(64, 64, player.spAtira1:getWidth(), player.spAtira1:getHeight())
  player.animation.atira1 = anim8.newAnimation(player.grid3('1-6', 1), 0.2)
  player.anim = player.animation.left
  player.lado = player.spLeft

  jogo.fonte = LG.newFont('font.TTF', 32)
  LG.setFont(jogo.fonte)
  player.collider = world:newBSGRectangleCollider(400, 250, 45, 70, 10)
  player.collider:setType('dynamic')
  player.collider:setFixedRotation(true)
  player.collider:setMass(1)

  if jogo.estado == "jogando" or jogo.estado == "cutscene" then
    carregarLinhas()
  end
  if jogo.estado == "jogando2" or jogo.estado == "cutscene2" then
    carregarLinhas2()
  end
end

-- Função de atualização do jogo
function love.update(dt)
  print("FPS: " .. love.timer.getFPS())
  if tempoBonusCooldown > 0 then
    tempoBonusCooldown = tempoBonusCooldown - dt -- Reduz o tempo restante
    if tempoBonusCooldown <= 0 then
      tempoCooldownTiro = 0.5
      player.speed = 200
    end
  end
  if jogo.estado == "cutscene2" then
    jogo.movimento = jogo.movimento - 70 * dt
  end

  -- Atualiza chuva apenas se estiver inicializada
  if (jogo.estado == "jogando" or jogo.estado == "cutscene") and jogo.chuva then
    jogo.chuva:update(dt)
  end
  local isMove = false
  if jogo.imagemFundo:isPlaying() == false then
    jogo.imagemFundo:seek(0) -- Volta para o início do vídeo
    jogo.imagemFundo:play()  -- Inicia a reprodução novamente
  end
  if jogo.estado == "pausado" then
    return
  end
  -- Atualiza o cooldown do pulo
  if player.jumpCooldown > 0 then
    player.jumpCooldown = player.jumpCooldown - dt
  end
  if player.danoTimer > 0 then
    player.danoTimer = player.danoTimer - dt
  end

  if LK.isDown("escape") then
    if jogo.exibirBotoes == true then
      jogo.exibirBotoes = false
    elseif jogo.exibirBotoes == false then
      jogo.exibirBotoes = true
    end
  end




  if not exibirBotoes then
    jogo.exibirMensagem1, jogo.exibirMensagem2, jogo.exibirBotoes = button.draw(
      jogo.exibirBotoes,
      jogo.posicaoBotaoX,
      jogo.posicaoBotaoY,
      jogo.larguraBotao,
      jogo.larguraBotaoBase,
      jogo.alturaBotaoBase,
      jogo.telaCheia,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2
    )
  end

  if jogo.exibirMensagem1 then
    local velx = 0
    local currentVelY = 0
    local _, vy = player.collider:getLinearVelocity()
    currentVelY = vy

    -- Movimento para a direita
    if LK.isDown("right", "d") then
      if player.x < (9500 - player.spRiht:getWidth()) then
        player.x = player.x + player.speed * dt
        velx = player.speed
        player.anim = player.animation.right
        player.lado = player.spRiht
        direcaoAtual = 1 -- Atualiza a direção para direita
        sons(jogo.sons, false, "andar")
      end
      isMove = true
    elseif LK.isDown("left", "a") then
      if player.x > 0 then
        player.x = player.x - player.speed * dt
        velx = -player.speed
        player.anim = player.animation.left
        player.lado = player.spLeft
        direcaoAtual = -1 -- Atualiza a direção para esquerda
        sons(jogo.sons, false, "andar")
      end
      isMove = true
    elseif cooldownTiro <= 0 and LK.isDown('f') then
      desenharTiros()
      criarTiro(player.x, player.y - 20, direcaoAtual) -- Cria o tiro na direção atual

      if direcaoAtual == 1 then
        player.anim = player.animation.atira
        player.lado = player.spAtira -- Atirando para a direita
      elseif direcaoAtual == -1 then
        player.anim = player.animation.atira1
        player.lado = player.spAtira1 -- Atirando para a esquerda
      end
      sons(jogo.sons, false, "atirar")
      cooldownTiro = tempoCooldownTiro -- Reseta o cooldown
    elseif not LK.isDown('f') then
      -- Reverte a animação para a de movimento ou parada
      if direcaoAtual == 1 then
        player.anim = player.animation.right
        player.lado = player.spRiht
      elseif direcaoAtual == -1 then
        player.anim = player.animation.left
        player.lado = player.spLeft
      end
    end
    if cooldownTiro > 0 then
      cooldownTiro = cooldownTiro - dt
    end



    player.collider:setLinearVelocity(velx, currentVelY)
  end

  if not isMove then
    if player.lado == player.spRiht then
      player.anim = player.animation.right
      player.lado = player.spRiht -- Atirando para a direita
      player.anim:gotoFrame(2)
    elseif player.lado == player.spLeft then
      player.anim = player.animation.left
      player.lado = player.spLeft -- Atirando para a esquerda
      player.anim:gotoFrame(2)
    end
    if jogo.exibirMensagem1 then
      sons(jogo.sons, false, "para")
    end
  end
  
  world:update(dt)
  player.x = player.collider:getX()
  player.y = player.collider:getY()

  player.anim:update(dt)
  local targetY = jogo.alturaTela / 2
  cam:lookAt(player.x, targetY)

  if cam.x < jogo.larguraTela / 2 then
    cam.x = jogo.larguraTela / 2
  elseif cam.x > jogo.mapaLargura - jogo.larguraTela / 2 then
    cam.x = jogo.mapaLargura - jogo.larguraTela / 2
  end
  atualizarInimigos(dt)
  atualizarTiros(dt)
  atualizarRaios(dt)

  if player.x >= 7457 and jogo.estado == "jogando" then
    jogo.cutscene = nil
    jogo.estado = "cutscene2"
  end
end

-- Função de desenho do jogo
function love.draw()
  local escala = math.max(jogo.escalaX, jogo.escalaY)
  if not jogo.exibirMensagem1 then
    love.graphics.draw(jogo.imagemFundo, 0, 0, 0, escala, escala)
  end

  if LK.isDown("up", "space", "w") then
    if player.jumpCooldown <= 0 then
      sons(jogo.sons, false, "pular")
      player.collider:applyLinearImpulse(0, -300) -- Aplica o impulso para o pulo
      player.jumpCooldown = 1                     -- Define o cooldown para o pulo
    end
  end

  if jogo.exibirMensagem2 then
    jogo.exibirMensagem2, jogo.exibirBotoes, jogo.telaCheia = opcao(
      jogo.posicaoBotaoX + 30,
      jogo.posicaoBotaoY - 40,
      atualizarTamanhoTela,
      jogo.exibirMensagem1,
      jogo.exibirMensagem2,
      jogo.sons,
      jogo.brilho,
      jogo.exibirBotoes,
      sounds
    )
    jogo.exibirBotoes = not jogo.exibirMensagem2
  end
  if jogo.exibirMensagem1 then
    if jogo.estado == "cutscene" then
      if not jogo.cutscene then
        jogo.cutscene = LG.newVideo('sprits/cutcine.ogv')
        jogo.cutscene:setFilter("linear", "linear")
        jogo.cutscene:play() -- Inicia a reprodução do vídeo
        sons(jogo.sons, false, nil)
      end
      if jogo.cutscene:isPlaying() then
        escala = math.max(jogo.larguraTela / jogo.cutscene:getWidth(), jogo.alturaTela / jogo.cutscene:getHeight())
        LG.draw(jogo.cutscene, 0, 0, 0, escala, escala)
        player.vida = 100
      end
      if not jogo.cutscene:isPlaying() then
        carregarInimigos(10)
        player.x = 345
        player.y = 130
        if player.collider then
          player.collider:setPosition(400, 250)
        end
        jogo.estado = "jogando"
        jogo.estadoAnterior = "jogando"
      end
    end
    if jogo.estado == "jogando" or jogo.estado == "pausado" then
      sons(jogo.sons, false, "jogando")
      jogo.escala = math.max(jogo.mapLargura, jogo.mapAltura)
      cam:attach()
      LG.push() -- Salva o estado atual da matriz de transformação
      LG.scale(jogo.escala, jogo.escala)
      gameMap:drawLayer(gameMap.layers["Fundo"])
      gameMap:drawLayer(gameMap.layers["Chao"])
      LG.pop() -- Restaura o estado da matriz de transformação
      desenharPlayer()
      desenharInimigos()
      desenharTiros()

      cam:detach()
      desenharVida()
      desenharMiniMapa()
      if player.x < 600 then
        desenharTutorial()
      end
    end
    if jogo.estado == "jogando2" or jogo.estado == "pausado" then
      local gameMap2 = sti('mapa/fase 1/fase2.lua')
      sons(jogo.sons, false, "jogando")
      jogo.escala = math.max(jogo.mapLargura, jogo.mapAltura)
      cam:attach()
      LG.push() -- Salva o estado atual da matriz de transformação
      LG.scale(jogo.escala, jogo.escala)
      gameMap2:drawLayer(gameMap2.layers["Fundo"])
      gameMap2:drawLayer(gameMap2.layers["Chao"])
      LG.pop() -- Restaura o estado da matriz de transformação
      desenharRaios()
      desenharPlayer()
      --world:draw()
      desenharInimigos()
      desenharTiros()
      cam:detach()
      desenharVida()
      desenharMiniMapa()
    end
    -- Desenha o tutorial SEMPRE fora do cam:attach/detach, para ficar fixo na tela

    if jogo.estado == "vitoria" then
      sons(jogo.sons, true, nil)
      if not jogo.cutscene then
        jogo.cutscene = LG.newVideo('sprits/cutcine3.ogv')
        jogo.cutscene:setFilter("linear", "linear")
        jogo.cutscene:play() -- Inicia a reprodução do vídeo
      end
      if jogo.cutscene:isPlaying() == false then
        resetarEixoY()
        jogo.cutscene = nil
        jogo.estado = "cutscene"
        sons(jogo.sons, true, nil)
        jogo.exibirMensagem1 = false
        jogo.exibirMensagem2 = true
      end
      if jogo.cutscene:isPlaying() then
        escala = math.max(jogo.larguraTela / jogo.cutscene:getWidth(), jogo.alturaTela / jogo.cutscene:getHeight())
        LG.draw(jogo.cutscene, jogo.movimento, 0, 0, escala, escala)
        player.vida = 200
      end
      if not jogo.cutscene:isPlaying() then
        resetarEixoY()
        jogo.exibirMensagem1 = false
        jogo.exibirMensagem2 = true
        jogo.cutscene = nil
        jogo.estado = "cutscene"
        sons(jogo.sons, true, nil)
        jogo.exibirMensagem1 = false
        jogo.exibirMensagem2 = true
      end
    end
    if jogo.estado == "cutscene2" then
      sons(jogo.sons, false, "cutscene2")
      if not jogo.cutscene then
        jogo.cutscene = LG.newVideo('sprits/cutcine2.ogv')
        jogo.cutscene:setFilter("linear", "linear")
        jogo.cutscene:play() -- Inicia a reprodução do vídeo
        sons(jogo.sons, false, nil)
      end
      if jogo.cutscene:isPlaying() == false then
        jogo.cutscene:seek(0) -- Volta para o início do vídeo
        jogo.cutscene:play()  -- Inicia a reprodução novamente
        jogo.movimento = 0
      end
      if jogo.cutscene:isPlaying() then
        escala = math.max(jogo.larguraTela / jogo.cutscene:getWidth(), jogo.alturaTela / jogo.cutscene:getHeight())
       
        LG.draw(jogo.cutscene, jogo.movimento, 0, 0, escala, escala)
        player.vida = 200
      end
      if not jogo.cutscene:isPlaying() then
        resetarEixoY2()
        carregarInimigos(8)
        carregarLinhas2()
        jogo.estado = "jogando2"
        jogo.estadoAnterior = "jogando2"
        jogo.cutscene = nil
      end
    end
  end
  if player.vida <= 0 then
    jogo.estado = "pausado"
    if suit.Button("Reiniciar", jogo.posicaoBotaoX, jogo.posicaoBotaoY + 50, jogo.larguraBotao, jogo.alturaBotao).hit then
      if jogo.estadoAnterior == "jogando2" then
        reiniciarJogo("jogando2")
      else
        reiniciarJogo("jogando")
      end
    end
    LG.setColor(0.5, 0.5, 0.5, 0.5)
    suit.Label("Game Over", jogo.posicaoBotaoX, jogo.posicaoBotaoY, jogo.larguraBotao, jogo.alturaBotao)
  end
  suit.theme.color = {
    normal = { bg = { 0.2, 0.2, 0.2 }, fg = { 1, 1, 1 } },
    hovered = { bg = { 0.5, 0.5, 0.5 }, fg = { 0, 0, 1 } },
    active = { bg = { 0.1, 0.1, 0.1 }, fg = { 0, 1, 0 } }
  }

  suit.draw()

  -- Desenha tutorial no canto inferior direito se estiver jogando
end
