--Resolutions
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600


--Controls speed of paddle
PADDLE_SPEED = 200

function love.load()
    --Setup filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --Setup retro font
    smallFont = love.graphics.newFont(32)
    scoreFont = love.graphics.newFont(64)

    --Initialize window
    function love.load()
        love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
            fullscreen = false,
            resizable = true,
            vsync = true
        })
    end

    --Initialize player scores
    player1Score = 0
    player2Score = 0

    --Store paddle positions on y axis
    player1Y = WINDOW_HEIGHT / 2 - 40
    player2Y = WINDOW_HEIGHT / 2 - 40

end

function love.update(dt)
    --Player 1 movement
    if love.keyboard.isDown('w') then
        player1Y = player1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    ---Player 2 movement
    if love.keyboard.isDown('up') then
        player2Y = player2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

function love.keypressed(key) 

    --Exit if Esc is pressed
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()

    --Display Welcome
    love.graphics.setFont(smallFont)
    love.graphics.printf('Welcome to Pong!', 0, 0, WINDOW_WIDTH, 'center')

    --Render scores
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), 0, 0)
    love.graphics.print(tostring(player2Score), WINDOW_WIDTH - 40, 0)

    --Render left paddle
    love.graphics.rectangle('fill', 10, player1Y, 20, 80)

    --Render right paddle
    love.graphics.rectangle('fill', WINDOW_WIDTH - 30, player2Y, 20, 80)

    -- render ball 
    love.graphics.rectangle('fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 8, 8)

end
