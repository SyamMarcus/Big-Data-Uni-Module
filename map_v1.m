    % Initialize X and Y variables to match the plot
    [X] = 30.05:0.1:69.95;                                                  
    [Y] = -24.95:0.1:44.95;   
    % Create figure to plot data on
    plot = figure();                                                     

    
    % Initialise colormap and figure Variables
    curFig = 1;                                                              
    curMap = 1;    
    mapList = {hsv,parula,hot,jet,copper,gray,cool,summer,winter,spring};                                                
    colormap(flipud(mapList{curMap}));                                       
    
    % Load all csv files in current Directory     
    files = dir(fullfile("./", strcat('*.','csv')));                       
    
    % Load data from current figure into an empty array Z
    Z = {}; 
    Z=flip(importdata(files(curFig).name));                                 
                                                                                 

    % Plot a base map of Europe using MatLab
    load coastlines;                                                        
    worldmap('Europe');                                                                          
    plotm(coastlat,coastlon)                                               
    
    % Display base map with green colour
    land = shaperead('landareas', 'UseGeoCoords', true);                   
    landColor = [0.5 0.7 0.4];
    geoshow(land, 'FaceColor', landColor)                             
    
    
    % Plot the Data with 0.4 alpha
    plotOzone = surfm(X, Y, Z, 'FaceAlpha', 0.4);       
    
    
    % Display info for user controls
    % Color Map text
    colorMapInfo = annotation('textbox', [0.01, 0.01, 0, 0.05],'String',... 
        '[M]:  Cycle Color Scheme');
    colorMapInfo.FontSize = 10;                                                
    colorMapInfo.FitBoxToText = 'on';                                         
        
    % Current figure text
    curFigInfo = annotation('textbox', [0.7 0.01, 1, 0.05],'String',...      
        '[N]:  Display Next Plot');
    curFigInfo.FontSize = 10;                                                
    curFigInfo.FitBoxToText = 'on';                                         
    
    
    % Create and position Colourbar
    colb = colorbar();                                                        
    set(colb, 'Position', [0.05 0.12 0.01 0.85] );                          
    colb.FontSize = 8;                                                       
    caxis([0, 1])                                                         
    
    % Infinite loop to change figure display
    while true                                                                
        
        % Update color map with current color scheme
        colormap(flipud(mapList{curMap}))                                  

        % Take Keyboard Input   
        try
            keyIsPressed = waitforbuttonpress; 
            % The catch statement ensures when the figure closes
            % Matlab does not check for current key press
        catch                                                               
            return                                                          
        end
        
        % if the user presses a key
        if keyIsPressed                           
            % if the pressed key is 'm', increment current color scheme
            if strcmp(get(plot, 'CurrentKey'), 'm')                      
                if curMap == length(mapList)                                
                    curMap = 1;                                             
                else                                            
                    curMap = curMap + 1;                                   
                end
            end
            
            % if the pressed key is 'n', increment current figure plot
            if strcmp(get(plot, 'CurrentKey'), 'n')            
                if curFig == length(files)                                  
                    curFig = 1;                                            
                else
                    curFig = curFig + 1;                                   
                end
                % Load the Z data for the new figure
                file = files(curFig).name;        
                Z=flip(importdata(file));          
                plotOzone.CData = Z;             
            end       
        end        
    end

    
    
    
    