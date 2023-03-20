function onStepHit()
	if stepHitFuncs[curStep] then
	stepHitFuncs[curStep]()
	end
end

stepHitFuncs = {	
	[159] = function()
		if (flashingLights) then
            cameraFlash('camGAME','FFFFFF',0.4,false);
        end			
	end,
	[544] = function()
		doTweenAlpha(getProperty('camHUD'), getProperty('camHUD'), 0.75, 0.2)
	end,
	[800] = function()
		doTweenAlpha(getProperty('camHUD'), getProperty('camHUD'), 1, 0.2)
	end,
}
