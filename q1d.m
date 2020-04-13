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

% On génère notre urne avec 5x (R)ouge, 5x (B)leu, 5x (V)ert, 5x (N)oir
balls_in_urn = gen_urn('RBVN', 5);
% Le joueur tire 5 balles.
nb_draws = 5;
% Pas de remise.
replacement = false;

% Compteur de mains obtenues.
% 1 : couleur
% 2 : carré
% 3 : full
% 4 : brelan
% 5 : double paire
% 6 : simple paire.
counter = zeros(6, 1);

% On génère l'arbre avec toutes les combinaisons.
tree = create_naive_tree(balls_in_urn, nb_draws, replacement);
events_nbr = length(tree);

% On parcourt liste générée par tree contenant ainsi tous les
% évènements (équiprobables) possibles.
% On compte simplement le nombre d'occurences de chaque main obtenue.
for curr = 1:events_nbr
    hand = tree(curr, :);
    gain = calc_gain(hand, 'BRNV');
        
    switch(gain)
        case 1000
            counter(1) = counter(1) + 1;
        case 700
            counter(2) = counter(2) + 1;
        case 450
            counter(3) = counter(3) + 1;
        case 200
            counter(4) = counter(4) + 1;
        case 75
            counter(5) = counter(5) + 1;
        case 0
            counter(6) = counter(6) + 1;
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
        for j = 1:total_colors
            for k = 1:balls_per_color
                urn((j-1) * balls_per_color + k) = colors(j);
            end
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