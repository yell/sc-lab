function hmove = gen_human_move( rno )
%GEN_HUMAN_MOVE Function to generate a human move substitute by some rule
%   Inputs: rno = the number of the current round
%   Outputs: hmove = integer {1,2,3} code of the move {rock,paper,scissors}
%
% OPTIONAL: This function can be helpful to test out different strategies

hmove = mod(rno,3)+1; % We dare you to think of a simpler rule... :)

end

