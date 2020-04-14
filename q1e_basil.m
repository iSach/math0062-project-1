%Ce script va nous permettre de calculer la probabilité de chaque main
%en fonction du nombre de couleurs présentes dans l'urne ainsi que
%l'espérance et la variance correspondante.
tic

%On veut commencer par créer notre tableau. Pour ne pas devoir modifier
%tout le code à chaque fois, on va partir de tab_colors pour générer notre
%tree. On ne devra modifier que tab_colors pour ajouter ou retirer des
%couleurs.
tab_colors = ['R' 'B' 'V' 'N' 'D' 'A' 'Z' 'E' 'F'];
taille_colors = length(tab_colors);
balls_in_urn = zeros(1, 5*taille_colors);

for i=1 : taille_colors 
    for  j=1 : 5
        d = 5*(i-1) + j;
        balls_in_urn(d) = tab_colors(i);
    end
end

balls_in_urn = char(balls_in_urn);

%Création de l'arbre
nb_draws = 5;
replacement = false;

tree = create_naive_tree(balls_in_urn,nb_draws,replacement);

taille = length(tree);

%On initialise les compteurs

nb_simple_paire = 0;
nb_double_paire = 0;
nb_famille = 0;
nb_brelan = 0;
nb_full = 0;
nb_carre = 0;
nb_couleur = 0;

%On va ensuite procéder comme à la q1d, en prenant en compte que le nombre
%de couleur vaut taille_colors et qu'on doit compter le nombre de familles

%On va analyser chaque main l'une après l'autre
for i=1 : taille    
    %On va générer un vecteur tab_nb_couleurs qui compte le nb de
    %répétitions de chaque couleur et sera de type [ nb_R nb_B nb_V nb_N ]
    tab_nb_couleurs = zeros(1,taille_colors);
    for k=1 : nb_draws
        for j=1 : taille_colors
            if tree(i,k) == tab_colors(j)
                tab_nb_couleurs(j) = tab_nb_couleurs(j) + 1;
                break
            end
        end
    end
    
    %Maintenant qu'on a notre tab_nb_couleurs, on va déterminer quel type
    %de main nous analysons et incrémenter le compteur correspondant
    for j=1 : taille_colors
        
        %Si on tombe sur un 5 ou un 4, pas de doute possible, c'est une
        %couleur ou un carré. On sort directement de la boucle après avoir
        %incrémenté le compteur correspondant
        if tab_nb_couleurs(j) == 5
            nb_couleur = nb_couleur + 1;
            break
        end
        
        if tab_nb_couleurs(j) == 4
            nb_carre = nb_carre + 1;
            break
        end
        
        %Si on tombe sur un 3, c'est qu'on a affaire soit à un brelan soit
        %un full. On teste si on a un 2 autre part dans le vecteur. Si
        %c'est le cas, on a un full, sinon on a un brelan
        if tab_nb_couleurs(j) == 3
            for d=1 : taille_colors
                if tab_nb_couleurs(d) == 2
                    nb_full = nb_full + 1;
                    break
                end
            end
            if tab_nb_couleurs(d) == 2
                break
            end
            nb_brelan = nb_brelan + 1;
            break
        end
        
        %Si on tombe sur un 2, c'est qu'on a affaire soit à une paire
        %simple, une paire double ou un full.
        if tab_nb_couleurs(j) == 2
            %on teste si c'est un full
            for d=1 : taille_colors
                if tab_nb_couleurs(d) == 3
                    nb_full = nb_full + 1;
                    break
                end
            end
            if tab_nb_couleurs(d) == 3
                break
            end
            %on teste mtn si c'est une double paire
            for d=1 : taille_colors
                if j ~= d
                    if tab_nb_couleurs(d) == 2
                        nb_double_paire = nb_double_paire + 1;
                        break
                    end
                end
            end
            if j ~= d 
                if tab_nb_couleurs(d) == 2
                    break
                end
            end
            
            %Si on n'a pas de full ou de double paire, alors c'est
            %forcément une paire simple
            nb_simple_paire = nb_simple_paire + 1;
            break
        end
        %Si l'itération arrive jusqu'ici, c'est qu'on est sur un 1 ou un
        %0. On va donc tester sur on est sur une famille
        z=0;
        for d=1 : taille_colors
            if tab_nb_couleurs(d) == 1
                z = z+1;
            end
        end
        if z == 5
            nb_famille = nb_famille + 1;
            break
        end
    end
end


%On peut maintenant calculer les probabilités de chaque main
p_simple_paire = nb_simple_paire /taille;
p_double_paire = nb_double_paire / taille;
p_famille = nb_famille / taille;
p_brelan = nb_brelan / taille;
p_full = nb_full / taille;
p_carre = nb_carre / taille;
p_couleur = nb_couleur / taille;

%et l'espérance du gain X
esperance = p_simple_paire*0 + p_double_paire*0.75 + p_famille*0.8 + p_brelan*2 + p_full*4.5 + p_carre*7 + p_couleur*10;

%ainsi que la variance (théorème de König-Huygens)
variance = p_simple_paire*0*0 + p_double_paire*0.75*0.75 + p_famille*0.8*0.8 + p_brelan*2*2 + p_full*4.5*4.5 + p_carre*7*7 + p_couleur*10*10 - esperance*esperance;

toc