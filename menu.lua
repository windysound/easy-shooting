function showmenu()
    -- 截取当前画面并进行处理
    love.graphics.captureScreenshot(function(imageData)
        -- 将截图的 ImageData 转换为 Image 以便显示
        local screenshot = love.graphics.newImage(imageData)
        local imgWidth, imgHeight = screenshot:getDimensions()

        -- 创建新的 ImageData 对象以便进行像素操作
        local imgData = imageData

        local kernalSize = 5  -- pixel radius
        local offset = math.floor(kernalSize / 2)

        -- 定义高斯模糊函数
        local function gaussian(x, y, r, g, b, a)
            -- 边界像素不处理
            if x - offset < 0 or x + offset >= imgWidth or y - offset < 0 or y + offset >= imgHeight then
                return r, g, b, a
            else
                sumR, sumG, sumB = 0, 0, 0
                for i = -offset + x, offset + x do
                    for j = -offset + y, offset + y do
                        local nr, ng, nb = imgData:getPixel(i, j)
                        sumR = sumR + nr
                        sumG = sumG + ng
                        sumB = sumB + nb
                    end
                end

                -- 计算平均值（模糊效果）
                local avgR = sumR / (kernalSize * kernalSize)
                local avgG = sumG / (kernalSize * kernalSize)
                local avgB = sumB / (kernalSize * kernalSize)

                return avgR, avgG, avgB, a
            end
        end

        -- 应用高斯模糊
        imgData:mapPixel(gaussian)

        -- 将处理后的 ImageData 转换为新的 Image
        local newImg = love.graphics.newImage(imgData)

        -- 在屏幕上绘制模糊后的图像
        love.graphics.draw(newImg, 0, 0, 0)
    end)
end
