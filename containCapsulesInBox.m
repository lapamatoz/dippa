function stadiums = containCapsulesInBox(stadiums, boxSize)
	stadiums(5,:) = mod(stadiums(5,:), 2*pi);
	%stadiums(3,q) = max(-boxSize(1)+r*0.7, min(boxSize(1)-r*0.7, stadiums(3,q)));
	%stadiums(4,q) = max(-boxSize(2)+r*0.7, min(boxSize(2)-r*0.7, stadiums(4,q)));
	stadiums(3,:) = max(-boxSize(1), min(boxSize(1), stadiums(3,:)));
	stadiums(4,:) = max(-boxSize(2), min(boxSize(2), stadiums(4,:)));
end