
    K=.06;
    number_of_types= 3; %The number of distinct styles of radar array element that are permitted in our array
    
    
    Lambda=.03;

    max_diameter = 100; %The maximum diamater of any given element in our array in meters
    min_diameter = 1 ;

    max_quantity = 50; %The maximum quantity of elements of a given type in our array
    min_quantity = 0;
       
    min_power = 0;
    max_power = 10;
    
    pop_size=4;

    pop=population.generate_population(pop_size, number_of_types, min_diameter, max_diameter, min_quantity, max_quantity, min_power, max_power)
    

function gain=gain_function(K,Lambda,member)
    gain=0;
    for f=1:3
        %gain=K*(pi*(D/Lambda))^2;
        gain= gain + member(f+3)*K*(pi*(member(f)/Lambda))^2;
    end
    
end

function cost=cost_function(z,y)
    cost=5;
end

%
%genotypes=population.generate_population()
%genotypes=population.test()
%gentoypes=population.sort_and_cull()
%genotypes=population.cross_procreate()
%