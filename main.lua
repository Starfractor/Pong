--Resolutions
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600


--Controls speed of paddle
PADDLE_SPEED = 500

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

    --Setup objects
    player1 = {
        x = 10, 
        y = WINDOW_HEIGHT / 2 - 40, 
        width = 20, 
        height = 80, 
        score = 0
    }

    player2 = {
        x = WINDOW_WIDTH - 30, 
        y = WINDOW_HEIGHT / 2 - 40, 
        width = 20, 
        height = 80, 
        score = 0
    }

    ball = {
        x = WINDOW_WIDTH / 2, 
        y = WINDOW_HEIGHT / 2, 
        dx = math.random(2) == 1 and 300 or -300,
        dy = math.random(-150, 150),
        size = 8
    }

    --Store paddle positions 
    player1X = 10
    player1Y = WINDOW_HEIGHT / 2 - 40
    player2X = WINDOW_WIDTH - 30
    player2Y = WINDOW_HEIGHT / 2 - 40

    --Setup game state
    gameState = 'start'

end

function love.update(dt)

    if gameState == 'play' then 
        --Player 1 movement
        if love.keyboard.isDown('w') and player1.y > 0 then
            player1.y = player1.y - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('s') and player1.y < WINDOW_HEIGHT - 80 then
            player1.y = player1.y + PADDLE_SPEED * dt
        end


        ---Player 2 movement
        if love.keyboard.isDown('i') and player2.y > 0 then
            player2.y = player2.y - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('k') and player2.y < WINDOW_HEIGHT - 80 then
            player2.y = player2.y + PADDLE_SPEED * dt
        end

        --If the ball hits player 1 paddle
        if collides(ball, player1) then
           ball.dx = -ball.dx * 1.03
           ball.x = player1.x + 20

           if ball.dy < 0 then
                ball.dy = -math.random(10, 50)
           else
                ball.dy = math.random(10, 50)
           end
        end 

        --If the ball hits player 2 paddle
        if collides(ball, player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 20
 
            if ball.dy < 0 then
                 ball.dy = -math.random(10, 150)
            else
                 ball.dy = math.random(10, 150)
            end
        end 

        --Make sure ball doesn't fall out of bounds
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
        end
         
        if ball.y >= WINDOW_HEIGHT then 
            ball.y = WINDOW_HEIGHT
            ball.dy = -ball.y
        end

        --Check if player 1 has scored
        if ball.x >= WINDOW_WIDTH then 
            player1.score = player1.score + 1
            resetBall()
        end

        --Check if player 2 has scored
        if ball.x <= 0 then 
            player2.score = player2.score + 1
            resetBall()
        end 

        --Move the ball
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt
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
            player1.score = 0
            player2.score = 0
            
            --Store paddle positions on y axis
            player1.y = WINDOW_HEIGHT / 2 - 40
            player2.y = WINDOW_HEIGHT / 2 - 40

            resetBall()

        end 
    end

    --Start game if enter is pressed
    if key == 'return' and gameState == 'start' then
        gameState = 'play'
    end 
end

function love.draw()

    --Display fonts
    love.graphics.setFont(smallFont)
    love.graphics.printf('Pong', 0, 0, WINDOW_WIDTH, 'center')
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1.score), 50, 0)
    love.graphics.print(tostring(player2.score), WINDOW_WIDTH - 90, 0)

    --Render objects
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)
    love.graphics.rectangle('fill', ball.x, ball.y, ball.size, ball.size)

end

--Resets the ball back to the center with a random speed
function resetBall() 
    ball.x = WINDOW_WIDTH / 2
    ball.y = WINDOW_HEIGHT / 2
    ball.dx = math.random(2) == 1 and 300 or -300
    ball.dy = math.random(-150, 150)
end 

--Checks if a ball is collides with a player
function collides(ball, player) 
    if ball.x > player.x + player.width or player.x > ball.x + ball.size then
        return false
    end

    if ball.y > player.y + player.height or player.y > ball.y + ball.size then
        return false
    end 

    return true
end 
