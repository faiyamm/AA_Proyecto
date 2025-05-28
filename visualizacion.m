function visualizacion(imagenes_procesadas, indices_orden, grupos, archivos)
% paso 5: función para mostrar los resultados de análisis
num_imagenes = length(imagenes_procesadas);

%figura 1: imgs ordenadas por color dominante
figure('Name', 'Imágenes ordenadas por color dominante', 'NumberTitle', 'off');
set(gcf, 'Position', [100, 100, 1200, 800]);

num_mostrar = min(12, num_imagenes);
for i = 1:num_mostrar
    subplot(3, 4, i);
    img_idx = indices_orden(i);
    img_rgb = hsv2rgb(imagenes_procesadas{img_idx});
    imshow(img_rgb);
    title(sprintf('%s\nColor: %.2f', archivos(img_idx).name, ...
        mean(imagenes_procesadas{img_idx}(:,:,1), 'all')));
end

%figura 2: imgs agrupadas por similitud
figure('Name', 'Grupos de imágenes similares', 'NumberTitle', 'off');
set(gcf, 'Position', [100, 100, 1200, 600]);

num_grupos_mostrar = min(3, length(grupos));
for g = 1:num_grupos_mostrar
    subplot(num_grupos_mostrar, 1, g);
    grupo_actual = grupos{g};
    num_img_grupo = min(5, length(grupo_actual));
    
    %mosaico horizontal de imágenes del grupo
    mosaico = [];
    for j = 1:num_img_grupo
        img_rgb = hsv2rgb(imagenes_procesadas{grupo_actual(j)});
        if isempty(mosaico)
            mosaico = img_rgb;
        else
            mosaico = [mosaico, ones(size(img_rgb,1), 10, 3), img_rgb];
        end
    end
    
    imshow(mosaico);
    title(sprintf('Grupo %d - %d imágenes', g, length(grupo_actual)));
end

if ~exist('resultados', 'dir')
    mkdir('resultados');
end

for g = 1:length(grupos)
    grupo_dir = sprintf('resultados/grupo_%02d', g);
    if ~exist(grupo_dir, 'dir')
        mkdir(grupo_dir);
    end
    
    for idx = grupos{g}
        img_rgb = hsv2rgb(imagenes_procesadas{idx});
        imwrite(img_rgb, fullfile(grupo_dir, archivos(idx).name));
    end
end

disp('Resultados guardados en carpeta "resultados".');
end