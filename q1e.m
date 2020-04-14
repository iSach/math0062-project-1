function [hands_prob, time, expectation, variance] = q1e(colors_nbr)
% Question 1(e).
% 
% Calcule et génère pour un nombre de couleurs entre 4 et 10 le temps
% nécessaire pour calculer les probabilités, l'espérance et la variance.
%
% Sortie :
%       time : Vecteur de longueur 10 avec les temps, en secondes
%              pour chacun des nombres de couleurs. time(1:3) = -1 car
%              on travaille avec 4 couleurs minimum.
%       expectation : l'espérance
%       variance : la variance
    
    tic;
    
    % Couleurs du jeu de base.
    std_colors = 'RBVN';
    % 16 couleurs éventuelles ajoutées en plus, pour avoir jusque 20.
    % On choisit arbitrairement des autres lettres pour
    % représenter chaque nouvelle couleur.
    add_colors = 'ACDEFGHIJKLMOPQT';

    % On ajoute colors_nbr - 4 couleurs, puisqu'on a déjà 4 de base.
    colors_to_add = colors_nbr - 4;

    % Selon le nombre de couleurs à ajouter spécifié par colors_nbr
    % On crée un vecteur contenant nos couleurs au total.
    chosen_colors = [std_colors, add_colors(1:colors_to_add)];

    urn = gen_urn(chosen_colors, 5);

    % Compteur de mains obtenues.
    % 1 : couleur
    % 2 : carré
    % 3 : full
    % 4 : brelan
    % 5 : double paire
    % 6 : simple paire.
    % 7 : Famille
    counter = zeros(7, 1);

    tree = create_naive_tree(urn, 5, false);
    events_nbr = length(tree);

    for curr = 1:events_nbr
        % Calculer nombre d'occurences de chaque couleur dans la main.
        color_count = zeros(colors_nbr, 1);
        for i = 1:5
            ball = tree(curr, i);
            for j=1:colors_nbr
                if chosen_colors(j) == ball
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
            case 1
                counter(7) = counter(7) + 1;
        end
    end

    % Les évènements étant équiprobables, la probabilité pour chaque main
    % est donnée en divisant le nombre d'occurences de l'évènements par
    % le nombre total d'évènements.
    hands_prob = 1 / events_nbr .* counter;

    % E(X) l'espérance
    expectation = hands_prob(6) * 0 + ...
                  hands_prob(5) * 75 + ...
                  hands_prob(7) * 80 + ...
                  hands_prob(4) * 200 + ...
                  hands_prob(3) * 450 + ...
                  hands_prob(2) * 700 + ...
                  hands_prob(1) * 1000;
    % E(X^2)       
    expectation_2 = hands_prob(6) * 0 + ...
                  hands_prob(5) * 75 * 75 + ...
                  hands_prob(7) * 80 * 80 + ...
                  hands_prob(4) * 200 * 200 + ...
                  hands_prob(3) * 450 * 450 + ...
                  hands_prob(2) * 700 * 700 + ...
                  hands_prob(1) * 1000 * 1000;
              
    % Formule de Konig-Huygens : Var(x) = E(X^2) - (E(X))^2  
    variance = expectation_2 - expectation^2;
    
    time = toc;
      
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