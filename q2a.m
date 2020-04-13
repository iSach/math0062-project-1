function [expected, variance] = q2a(n)
% Question 2a)
% Calcule une approximation empirique de l'espérance et de la variance en
% calculant respectivement une moyenne empirique, et une variance 
% empirique.
%
% Entrée :
%   n : Taille de l'échantillon d'essais.
%
% Sortie :
%   expected : Approximation de l'espérance par la moyenne empirique.
%   variance : Approximation de la variance par la variance empirique.

% Générer et remplir l'urne.
% 5 (B)leues, 5 (R)ouges, 5 (N)oires, 5 (V)ertes.
colors = 'BRNV';
balls_per_color = 5;

urn = gen_urn(colors, balls_per_color);

results = sparse(n, 1);

expected = 0;
variance = 0;

% On a besoin de la moyenne empirique complète avant de calculer
% la variance empirique qui en dépend à chaque itération.
for l = 1:n
    hand = gen_random_hand(urn, 5);
    gain = calc_gain(hand, colors);
    results(l) = gain;
    expected = expected + gain;
end

expected = expected / n;

for l = 1:n
    x = results(l);
    variance = variance + (x - expected)^2;
end

variance = variance / n;

    function urn = gen_urn(colors, balls_per_color)
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

    function hand = gen_random_hand(urn, balls_picked)
    % Génère une main du jeu.
    % 
    % Entrée :
    %       urn : vecteur contenant les éléments de l'urne.
    %             exemple : 'RRNNBB' pour 2 rouges, 2 noires et 2 bleues.
    %       balls_picked : Le nombre de balles à tirer dans l'urne.
    % Sortie :
    %       hand : La main générée.
    
        column_urn = urn(:);
        hand = blanks(balls_picked)';
        
        for i = 1:balls_picked
            ball = randsample(column_urn, 1); % On pioche 1 balle.
            hand(i) = ball; % On ajoute cette balle à la main.
            column_urn(find(column_urn == ball, 1)) =  []; % On retire.
        end
    end

    function gain = calc_gain(hand, colors)
    % Calcule le gain en fonction de la main obtenue.
    %
    % Paire   -> 0
    % 2-Paire -> 75
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
        end
    end
end