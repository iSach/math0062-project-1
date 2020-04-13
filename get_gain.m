function gain = get_gain(hand, colors)
% Calcule le gain en fonction de la main obtenue.
%
% Supporte la famille comme main en plus.
%
% Paire   -> 0
% 2-Paire -> 75
% Famille -> 80
% Brelan  -> 200
% Full    -> 450
% Carré   -> 700
% Couleur -> 1000
%
% Exemple : calc_gain('RBVVV', colors) -> 200 (Brelan)

    hand = hand(:);
    colors = colors(:);

    % Calculer nombre d'occurences de chaque couleur dans la main.
    color_nbr = zeros(size(colors, 1), 1);
    for i = 1:size(hand, 1)
        index = find(colors == hand(i));
        color_nbr(index) = ...
            color_nbr(index) +  1;
    end

    % Trie par ordre décroissant pour identifier le nombre le + grand.
    color_nbr = sort(color_nbr, 'descend');

    % Comparaison et identification de chaque cas.
    switch color_nbr(1)
        case 5 % Couleur
            gain = 1000;
            return
        case 4 % Carré
            gain = 700;
            return
        case 3 % Full ou Brelan
            if color_nbr(2) == 2 % 3 et 2 -> Full
                gain = 450;
                return
            end

            gain = 200; % Brelan sinon.
            return
        case 2
            if color_nbr(2) == 2 % 2 et 2 -> Double Paire
                gain = 75;
                return
            end

            gain = 0; % Paire simple sinon.
            return
        case 1
            gain = 80;
            return
    end
end