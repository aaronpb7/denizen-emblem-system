# Letter from Promachos to BrickmasterZ2
# A thank-you book rewarding 30 Demeter Keys for their spawn building

promachos_letter_brickmaster:
    type: book
    title: <&6>Letter from Promachos
    author: <&e>Promachos
    signed: true
    text:
    - <&6><&l>To BrickmasterZ2,<n><n><&0>I write to you with gratitude, mortal.<n><n>The structure you raised at spawn is no mere building.<n><n><&8><&o>~ Promachos
    - <&0>It is a monument that bridges men and the heavens above.<n><n>When I stand before it, I feel the Gods draw nearer.
    - <&0>The pillars reach toward Olympus as though <&6>Athena<&0> guided your hands.<n><n>You have brought the divine closer to this mortal plane.
    - <&0>For this sacred gift, I bestow upon you a reward from the harvest goddess.<n><n><&6><&l>30 Demeter Keys
    - <&0>May <&6>Demeter<&0> smile upon you always.<n><n>The Gods do not forget those who honour them.<n><n>Build well, <&6>BrickmasterZ2<&0>.
    - <&0>With divine respect,<n><n><&6><&l>Promachos<n><&8><&o>Herald of the Gods

promachos_reward_brickmaster:
    type: task
    debug: false
    script:
    - give promachos_letter_brickmaster
    - give demeter_key quantity:30
    - narrate "<&e>[Promachos]<&r> <&7>A letter and reward have been delivered to you."
    - playsound <player> sound:entity_experience_orb_pickup
    - title "title:<&6>Gift from Promachos" "subtitle:<&e>30 Demeter Keys received" fade_in:10t stay:60t fade_out:20t targets:<player>
