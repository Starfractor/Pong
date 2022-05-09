--Resolutions
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600


--Controls speed of paddle
PADDLE_SPEED = 200

function love.load()
    --Setup window
    love.window.setTitle('Pong')

    --Hides Mouse
    love.mouse.setVisible(false)

    --Setup font sizes
    smallFont = love.graphics.newFont(32)
    scoreFont = love.graphics.newFont(64)

    --Generate seed
    math.randomseed(os.time())

    --Initialize window
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    --Initialize player scores
    player1Score = 0
    player2Score = 0

    --Store paddle positions 
    player1X = 10
    player1Y = WINDOW_HEIGHT / 2 - 40
    player2X = WINDOW_WIDTH - 30
    player2Y = WINDOW_HEIGHT / 2 - 40

    --Store paddle and ball size
    paddleWidth = 20
    paddleHeight = 80
    ballSize = 8

    --Store ball position and starting speed
    ballX = WINDOW_WIDTH / 2
    ballY = WINDOW_HEIGHT / 2
    ballDX = math.random(2) == 1 and 200 or -200
    ballDY = math.random(-100, 100)

    --Setup game state
    gameState = 'start'

end

function love.update(dt)

    if gameState == 'play' then 
        --Player 1 movement
        if love.keyboard.isDown('w') and player1Y > 0 then
            player1Y = player1Y - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('s') and player1Y < WINDOW_HEIGHT - 80 then
            player1Y = player1Y + PADDLE_SPEED * dt
        end


        ---Player 2 movement
        if love.keyboard.isDown('i') and player2Y > 0 then
            player2Y = player2Y - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('k') and player2Y < WINDOW_HEIGHT - 80 then
            player2Y = player2Y + PADDLE_SPEED * dt
        end

        --If the ball hits player 1 paddle
        if ballX <= player1X + paddleWidth and player1X <= ballX + ballSize and ballY <= player1Y + paddleHeight and player1Y <= ballY + ballSize then
           ballDX = -ballDX * 1.03
           ballX = player1X + 20

           if ballDY < 0 then
                ballDY = -math.random(10, 150)
           else
                ballDY = math.random(10, 150)
           end
        end 

        --If the ball hits player 2 paddle
        if ballX <= player2X + paddleWidth and player2X <= ballX + ballSize and ballY <= player2Y + paddleHeight and player2Y <= ballY + ballSize then
            ballDX = -ballDX * 1.03
            ballX = player2X - 20
 
            if ballDY < 0 then
                 ballDY = -math.random(10, 150)
            else
                 ballDY = math.random(10, 150)
            end
        end 

        --Make sure ball doesn't fall out of bounds
        if ballY <= 0 then 
            ballY = 0
            ballDY = -ballDY
        end
         
        if ballY >= WINDOW_HEIGHT then 
            ballY = WINDOW_HEIGHT
            ballDY = -ballDY
        end

        --Check if player 1 has scored
        if ballX >= WINDOW_WIDTH then 
            player1Score = player1Score + 1
            ballX = WINDOW_WIDTH / 2
            ballY = WINDOW_HEIGHT / 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end 

        --Check if player 2 has scored
        if ballX <= 0 then 
            player2Score = player2Score + 1
            ballX = WINDOW_WIDTH / 2
            ballY = WINDOW_HEIGHT / 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end 

        --Move the ball
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end 

end

function love.keypressed(key) 

    --If Esc is pressed
    if key == 'escape' then
        if gameState == 'start' then
            love.event.quit()
        elseif gameState == 'play' then
            gameState = 'start'
            --Reset Scores 
            player1Score = 0
            player2Score = 0
            
            --Store paddle positions on y axis
            player1Y = WINDOW_HEIGHT / 2 - 40
            player2Y = WINDOW_HEIGHT / 2 - 40

            --Store ball position and starting speed
            ballX = WINDOW_WIDTH / 2
            ballY = WINDOW_HEIGHT / 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end 
    end

    --Start game if enter is pressed
    if key == 'return' and gameState == 'start' then
        gameState = 'play'
    end 
end


function love.draw()

    --Display Welcome
    love.graphics.setFont(smallFont)
    love.graphics.printf('Pong', 0, 0, WINDOW_WIDTH, 'center')

    --Render scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), 50, 0)
    love.graphics.print(tostring(player2Score), WINDOW_WIDTH - 90, 0)

    --Render left paddle
    love.graphics.rectangle('fill', player1X, player1Y, paddleWidth, paddleHeight)

    --Render right paddle
    love.graphics.rectangle('fill', player2X, player2Y, paddleWidth, paddleHeight)

    -- render ball 
    love.graphics.rectangle('fill', ballX, ballY, ballSize, ballSize)

end
