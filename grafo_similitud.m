function [grupos, matriz_adyacencia] = grafo_similitud(colores_dominantes, umbral)
%paso 3: función para construir el grafo de similitud y encontrar grupos de imágenes

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

disp(['Se formaron ' num2str(id_grupo) ' grupos de imágenes similares.']);
end