function [hands_prob, expectation, variance] = q1d()
% Question 1(d).
% Calcule par recherche exhaustive la probabilité de chaque main, ainsi
% que l'espérance et la variance.
%
% Sortie :
%       hands_prob : Vecteur colonne contenant les probabilités de
%                    chaque main en partant de la couleur jusqu'à la
%                    paire simple.
%       expectation: Espérance.
%       variance   : La variance.
%

    % Couleurs du jeu de base.
    colors = 'RBVN';

    urn = gen_urn(colors, 5);

    % Compteur de mains obtenues.
    % 1 : couleur
    % 2 : carré
    % 3 : full
    % 4 : brelan
    % 5 : double paire
    % 6 : simple paire.
    counter = zeros(6, 1);

    tree = create_naive_tree(urn, 5, false);
    events_nbr = length(tree);

    for curr = 1:events_nbr
        % Calculer nombre d'occurences de chaque couleur dans la main.
        color_count = zeros(4, 1);
        for i = 1:5
            ball = tree(curr, i);
            for j=1:4
                if colors(j) == ball
                    color_count(j) = color_count(j) +  1;
                end
            end
        end

        % Trie par ordre décroissant pour identifier le nombre le + grand.
        color_count = sort(color_count, 'descend');

        % Comparaison et identification de chaque cas.
        switch color_count(1)
            case 5 % Couleur
                counter(1) = counter(1) + 1;
            case 4 % Carré
                counter(2) = counter(2) + 1;
            case 3 % Full ou Brelan
                if color_count(2) == 2 % 3 et 2 -> Full
                    counter(3) = counter(3) + 1;
                else
                    counter(4) = counter(4) + 1;
                end
            case 2
                if color_count(2) == 2 % 2 et 2 -> Double Paire
                    counter(5) = counter(5) + 1;
                else
                   counter(6) = counter(6) + 1;
                end
        end
    end

    % Les évènements étant équiprobables, la probabilité pour chaque main
    % est donnée en divisant le nombre d'occurences de l'évènements par
    % le nombre total d'évènements.
    hands_prob = 1 / events_nbr .* counter;

    % E(X) l'espérance
    expectation = hands_prob(6) * 0 + ...
                  hands_prob(5) * 75 + ...
                  hands_prob(4) * 200 + ...
                  hands_prob(3) * 450 + ...
                  hands_prob(2) * 700 + ...
                  hands_prob(1) * 1000;
    % E(X^2)       
    expectation_2 = hands_prob(6) * 0 + ...
                  hands_prob(5) * 75 * 75 + ...
                  hands_prob(4) * 200 * 200 + ...
                  hands_prob(3) * 450 * 450 + ...
                  hands_prob(2) * 700 * 700 + ...
                  hands_prob(1) * 1000 * 1000;
              
    % Formule de Konig-Huygens : Var(x) = E(X^2) - (E(X))^2  
    variance = expectation_2 - expectation^2;
    
    function urn = gen_urn(colors, balls_per_color)
    % Génère une urne avec balls_per_color fois chaque couleur.
    % exemple : gen_urn('BRNV', 5); pour cet exercice.
        colors = colors(:);
        total_colors = size(colors, 1);
        urn = blanks(total_colors * balls_per_color)';
        for col = 1:total_colors
            for k = 1:balls_per_color
                urn((col-1) * balls_per_color + k) = colors(col);
            end
        end
    end
end