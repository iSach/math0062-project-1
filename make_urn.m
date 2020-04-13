function urn = make_urn(colors, balls_per_color)
% Génère une urne avec balls_per_color fois chaque couleur.
% exemple : gen_urn('BRNV', 5); pour cet exercice.
    colors = colors(:);
    total_colors = size(colors, 1);
    urn = blanks(total_colors * balls_per_color)';
    for j = 1:total_colors
        for k = 1:balls_per_color
            urn((j-1) * balls_per_color + k) = colors(j);
        end
    end
end  