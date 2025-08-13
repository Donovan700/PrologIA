:- discontiguous person/1, place/1, suspect/1, complice/2, present/3, crime/3, testimonial/2, defense/2.

person(to).
person(zolicon).
person(heihachi).
person(joker).
person(pimasy).
person(occ).
person(alain).

place(house).
place(bank).
place(gym).

suspect(to).
suspect(heihachi).
suspect(joker).

complice(occ, murder).
complice(zolicon, robery).

present(occ, gym, 15).
present(to, gym, 15).
present(heihachi, house, 22).
present(joker, bank, 8).

crime(robery, bank, car).
crime(murder, gym, alain).
crime(agression, house, pimasy).

testimonial(occ, "I saw to commiting murder").
testimonial(pimasy, "heihachi agressed me at home at 22").
testimonial(zolicon, "joker is a bank robber").

defense(to, "I did it, I did it for The Rock").
defense(heihachi, "Pimasy was a p*ssy").
defense(joker, "It was not me, it was To").

suspect_with_alibi(Suspect, Person):-
    suspect(Suspect),
    \+ present(Suspect, _ , _),
    \+ testimonial(Person, _),
    write(Suspect), write(' has alibi').

suspect_without_alibi(Suspect, Place):-
    suspect(Suspect),
    present(Suspect, Place , _).

coupable(Suspect, Person, Place):-
    suspect_without_alibi(Suspect, Place),
    crime(_, _, Person),
    \+ defense(Suspect, _),
    testimonial(Person, _).

non_coupable(Suspect, Person):-
    suspect_with_alibi(Suspect, Person),
    defense(Suspect, _),
    \+ crime(_ , _ , Person).
