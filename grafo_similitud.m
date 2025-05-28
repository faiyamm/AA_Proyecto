function [grupos, matriz_adyacencia] = grafo_similitud(colores_dominantes, umbral, imagenes_procesadas)
    %paso 3: función para construir el grafo de similitud y encontrar grupos de imágenes
    if nargin < 3
        imagenes_procesadas = [];
    end

    num_imagenes = length(colores_dominantes);
    matriz_adyacencia = zeros(num_imagenes);

    % construir matriz de adyacencia
    for i = 1:num_imagenes
        for j = i+1:num_imagenes
            diferencia = abs(colores_dominantes(i) - colores_dominantes(j));
            if diferencia < umbral
                matriz_adyacencia(i,j) = 1;
                matriz_adyacencia(j,i) = 1;
            end
        end
    end

    % bfs para encontrar componentes conectados
    visitado = zeros(num_imagenes, 1);
    grupos = {};
    id_grupo = 0;

    for i = 1:num_imagenes
        if ~visitado(i)
            id_grupo = id_grupo + 1;
            cola = i;
            visitado(i) = 1;
            grupos{id_grupo} = i;
            
            while ~isempty(cola)
                actual = cola(1);
                cola(1) = [];
                
                vecinos = find(matriz_adyacencia(actual, :) == 1);
                for v = vecinos
                    if ~visitado(v)
                        visitado(v) = 1;
                        grupos{id_grupo} = [grupos{id_grupo}, v];
                        cola = [cola, v];
                    end
                end
            end
        end
    end

    % añadir encabezados con nombres de colores a cada grupo
    for g = 1:length(grupos)
        % calcular el color promedio del grupo
        color_promedio = mean(colores_dominantes(grupos{g}));
        
        % convertir valor numérico a nombre de color
        nombre_color = obtener_nombre_color(color_promedio);
        
        % mostrar información del grupo
        disp(['Grupo ' num2str(g) ': ' nombre_color ' - Contiene ' num2str(length(grupos{g})) ' imágenes']);
    end

    disp(['Se formaron ' num2str(id_grupo) ' grupos de imágenes similares.']);

    % visualizar los grupos con gráficos si hay imágenes disponibles
    if ~isempty(imagenes_procesadas)
        visualizar_grupos(grupos, colores_dominantes, imagenes_procesadas);
    end
end

function nombre = obtener_nombre_color(valor_hue)
    if valor_hue < 0.05 || valor_hue >= 0.95
        nombre = 'Rojo';
    elseif valor_hue < 0.10
        nombre = 'Rojo-Naranja';
    elseif valor_hue < 0.16
        nombre = 'Naranja';
    elseif valor_hue < 0.25
        nombre = 'Amarillo';
    elseif valor_hue < 0.35
        nombre = 'Verde-Limón';
    elseif valor_hue < 0.45
        nombre = 'Verde';
    elseif valor_hue < 0.55
        nombre = 'Verde-Azulado';
    elseif valor_hue < 0.65
        nombre = 'Azul-Celeste';
    elseif valor_hue < 0.75
        nombre = 'Azul';
    elseif valor_hue < 0.85
        nombre = 'Azul-Violeta';
    elseif valor_hue < 0.95
        nombre = 'Violeta';
    end
end

function visualizar_grupos(grupos, colores_dominantes, imagenes_procesadas)
    % función para visualizar los grupos de imágenes
    num_grupos = length(grupos);
    
    % calcular distribución de figuras (filas y columnas)
    filas = ceil(sqrt(num_grupos));
    cols = ceil(num_grupos/filas);
    
    figure('Name', 'Grupos de Imágenes por Similitud de Color', 'Position', [100, 100, 1000, 800]);
    
    for g = 1:num_grupos
        subplot(filas, cols, g);
        
        % bbtener imágenes del grupo
        indices = grupos{g};
        num_imgs = length(indices);
        
        % calcular distribución para este grupo
        tam_panel = ceil(sqrt(num_imgs));
        
        % crear mosaico de imágenes
        montaje = zeros(tam_panel*64, tam_panel*64, 3);
        
        for i = 1:num_imgs
            if i <= tam_panel*tam_panel
                idx = indices(i);
                img = imagenes_procesadas{idx};
                
                % redimensionar imagen para el mosaico
                img_resized = imresize(img, [64 64]);
                
                % calcular posición en el mosaico
                row = floor((i-1)/tam_panel);
                col = mod(i-1, tam_panel);
                
                % colocar imagen en el mosaico
                montaje(row*64+1:(row+1)*64, col*64+1:(col+1)*64, :) = img_resized;
            end
        end
        
        % mostrar el mosaico
        imshow(montaje);
        
        % obtener nombre del color del grupo
        color_promedio = mean(colores_dominantes(indices));
        nombre_color = obtener_nombre_color(color_promedio);
        
        % añadir título
        title(['Grupo ' num2str(g) ': ' nombre_color ' (' num2str(num_imgs) ' imágenes)']);
    end
end