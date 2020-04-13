function [mean_expected, mean_variance, variance_expected, ...
    variance_variance] = q2b(n)
% Question 2(b)
% Calcule les moyennes et variances empiriques de 1000
% calculs des estimateurs de l'exercice 2(a)
%
% Entrée :
%     n : Nombre de tests à faire dans chaque calcul de l'estimateur.
% Sortie :
%     mean_expected : Moyenne empirique de l'estimateur Espérance.
%     mean_variance : Variance empirique de l'estimateur Espérance.
%     variance_expected : Moyenne empirique de l'estimateur Variance.
%     variance_variance : Variance empirique de l'estimateur Variance.
%

    mean_expected = 0;
    mean_variance = 0;
    variance_expected = 0;
    variance_variance = 0;

    mean_results = sparse(1000, 1);
    variance_results = sparse(1000, 1);
    
    for i = 1:1000
        [esp, var] = q2a(n);
        mean_results(i) = esp;
        variance_results(i) = var;
        mean_expected = mean_expected + esp;
        variance_expected = variance_expected + var;
    end
    
    mean_expected = mean_expected / 1000;
    variance_expected = variance_expected / 1000;
    
    for i = 1:1000  
        x_esp = mean_results(i);
        mean_variance = mean_variance + (x_esp - mean_expected)^2;
        
        x_var = variance_results(i);
        variance_variance = variance_variance + (x_var - ...
            variance_expected)^2;
    end
    
    mean_variance = mean_variance / 1000;
    variance_variance = variance_variance / 1000;

end