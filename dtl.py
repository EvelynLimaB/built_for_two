#!/usr/bin/env python3
"""
generate_dtl_files.py
Overwrites all timeline files with corrected Dialogic 2 syntax.
Run this from the project root folder.
"""

import os

OUTPUT_DIR = "./timelines"

# -------------------- File Contents --------------------
FILES = {
    "ch1_master.dtl": """# ch1_master.dtl
label start

set {BelleArrived} = false
set {BelleLivingHere} = false
set {PastaBurned} = false

jump ch1_scene1_wakeup/
""",

    "ch1_scene1_wakeup.dtl": """# ch1_scene1_wakeup.dtl
label start

[background path="res://backgrounds/daisy_bedroom.png" fade="1.0"]
join Daisy (neutral) left

Daisy (sleepy): Uhnn...
Daisy (sleepy): Whaaht time ish it now??
Daisy (sleepy): 16:20?? Just a nap my ass! It's a whole new day…
Daisy (stretch): I can't rest at all. A few more hours wouldn't make it better I guess.. I gotta pee blehg.

[background path="res://backgrounds/bathroom.png" fade="0.8"]
update Daisy (neutral) center [move_time="0.6" move_trans="Quad" move_ease="InOut"]

Daisy: Turn the light of the bathroom... Hunf, miserable.
Daisy: How long has it been since I last looked at the mirror?
Daisy: I need to wash my hair, and shave… I'll deal with my hair later.
Daisy (thinking): *shaving sound*

[audio path="res://audio/sfx/doorbell.wav"]

Daisy (shocked): AAAAFUCK!
Daisy (hurt): I hate razors. …fuck.
Daisy (walking): Have I ordered anything? Why is someone ringing my door…
Daisy (surprised): Belle?!

[audio path="res://audio/sfx/door_open.wav"]
join Belle (neutral) right [animation="Fade Up" length="0.5" wait="true"]

Daisy (happy): Belle!
Daisy (teary): Where have you been?! Why haven't you picked up my calls? Why do you look like a twig?
Belle (warm): Missed you too, Daisies! May I come in?
Daisy: Of course, girl, just… listen, I'm not complaining, I'm just confused; You've disappeared for so long and now you appear at my front step? Like, okay, but why? What happened to you?
Belle (apologetic): Sorry for not answering you sis, I just didn't want you to worry! By the way, you're bleeding.
Daisy (neutral): I know, I'll take care of it, just tell me what's going on. Those geezers did something to you?
Belle: Oh… No, not really. I haven't talked to them for a while now. I ran away!
Daisy (shocked): WHAT?! WHY?! WHEN?! WHY DIDN'T YOU TELL ME?! WHERE HAVE YOU BEEN?!
Belle (smiling): Relax, pretty face, I'm okay! Like I said, I didn't want to worry you.
Belle: Mom and pops were being more annoying than usual and I decided I didn't want to deal with their bullshit anymore. It's been great!
Daisy (sad): Belle…
Belle: What? I said it's been great.
Daisy: When exactly did you leave?
Belle (thinking): It's been like… I dunno, a year? I'm not that good remembering that type of stuff.
Daisy (teary): Belle… where have you been all this time?
Belle (dismissive): Been here and there. Stayed with some friends for a while! Well… ex-friends now, but that doesn't matter.
Daisy (angry): Shut the fuck up!
Daisy: You've been homeless for more than a year when you knew you could have just called me and lived with me all this time… Why?
Belle (silent): ...
Daisy (pleading): Belle?
Belle: ...
Daisy (demanding): Answer me!
Belle (mischievous): But you told me to shut up, he he!
Daisy (exasperated): Arrrg, for fuck sake! I don't care anymore! You're living with me, liking you or not!
Belle (grinning): Aye aye, captain! So, where do I stay?
Daisy: My bed isn't built for two, so you'll have to get the sofa treatment.
Belle (bright): Hey sis, cheer up. It's okay! I just haven't been able to get a job and all. Just give me some weeks and I'll get out of your—
Daisy (firm): No.
Belle: No? What do you mean—
Daisy: It means I'm tired of your bullshit! Listen to me, I don't care if you get a job or not, you're going to live with me. I'm paid enough to take care of us both, so I'm not letting you run away from me again.
Belle (hesitant): But Day… I really don't want to be—
Daisy (interrupting): Let me finish! I have two conditions.
Daisy: First one, is that you clean after yourself, I can already deal with the rest of the housework, just don't give me more shit.
Daisy: Second one… I kinda can't afford to feed us both in the way I usually eat so, you'll have to cook for us both. Agreed?
Belle (soft): ... Is that… really it?
Daisy: Any objection?
Belle (teary): It feels… too little… Isn't there anything else you'd like me to do?
Daisy (thinking): Hmm, not really. I've been living alone for quite some time so I already got the hang of stuff. I dunno if there's something else you can do.
Belle (excited): Actually, I can think of something!
Daisy: What?
Belle (playful): Your hair, babygirl! It's a mess! Let me comb it for you, like we used to do!
Daisy (annoyed): Fuck off with that 'babygirl' bullshit, I'm older than you!
Belle (pleading): Oh please, please, please, let me do it for you!
Daisy (flat): Miss me with that borzoi face…
Belle (puppy eyes): ...
Daisy (sigh): Argh fine! You can comb my hair while I work, but don't distract me!
Belle (joyful): YAAAY! You're the best big sis ever!!

set {BelleArrived} = true
set {BelleLivingHere} = true

[end_timeline]
""",

    "ch1_scene2_night_and_bike.dtl": """# ch1_scene2_night_and_bike.dtl
label start

[background path="res://backgrounds/daisy_bedroom_night.png" fade="1.0"]
join Daisy (neutral) left
leave Belle

Daisy (tired): To think organizing a few bags would be so exhausting, huh...

Narrator: So much time away, it's refreshing to see how much she's grown. I was afraid to never really see her again. To see her turning out to be such a woman— I'm glad.
Narrator: My hair feels so fluffy. The way she combed my hair really made me feel like we were kids again.
Narrator: I almost forgot how nice it felt to have her next to me. I missed her so much. These plushies are comfy, but I wish she'd be here with me...
Narrator: Ah... I feel... strange. Why am I so... warm...?
Narrator: I guess I'm just... happy. How ironic, huh. It's really been a while...
Narrator: Doesn't matter! It's better if I just focus on what I'll have to do now that she's here. I'll receive my payment in two days. After that, I'll carry her to the nearest supermarket.
Narrator: Urgh! My guts ache even just thinking about it. Guess that's what happens when you're a lazy bitch that's afraid of sunlight.
Narrator: Either way, I need to be responsible for her. I can't let whatever happened to her in this whole year happen again. I'll never let anything bad happen to her again...
Narrator: Uhh, I'm so tired… I couldn't even get much work done today. Maybe I should do somme worrh…—
Daisy (sleepy): ...

# Bike ride
[background path="res://backgrounds/hill_road.png" fade="1.0"]
join Belle (neutral) right

Daisy (neutral): ...
Belle (worried): Are you really sure this is the fastest way?
Daisy: Isabelle, I have lived here since I was 18, what do you think?
Belle (frightened): It's so steep… I don't have the slightest faith in this ride either.
Daisy: You've been a pain in the ass since we've stepped out of the door.
Belle: This is completely different! You're trying to kill us both!
Daisy: It's. Just. A. Slope. Could you please stop?
Belle (smirk): Day, may I sleep in your bed tonight?
Daisy (flustered): W-What?!
Belle (mocking): No, right? Because it's a single bed, right? Not built for two, right?
Daisy: Belle. What the fuck are you talking about?
Belle: THIS BICYCLE. IS. CLEARLY. NOT.
Daisy: Belle…
Belle: What, my beautiful princess with a disorder? Wait… what are you doing? No, no, NO, NO NO NO–AAAAAAAAAAAAAAAHHHHHHHHH

[background path="res://backgrounds/hill_fast.png" fade="0.3"]

Narrator: The sensation of the wind on my face, the pressure in my chest, the warmth of her holding me— sooooooo tightly.
Belle (faint): MOTHERFUCKER
Narrator: Whimsical. Like we've traveled to a time when we were both so young and free.
Belle (echo): SLOOOOW DOOOOOOWN
Narrator: A time when the future seemed so far away, yet so hopeful. I miss those days. I miss feeling… Alive.
Belle (echo): DAISYYYYYYY
Narrator: I missed you so much, Belle…
Belle (urgent): DAISY! THE CURVE!
Daisy (startled): …hm? Wha— Oh.

[audio path="res://audio/sfx/crash.wav"]
[background path="res://backgrounds/grass_field.png" fade="0.5"]

Daisy (dizzy): ...
Belle (silent): ...
Daisy: .........
Belle (stern): Daisy Heart.
Daisy: ….
Belle: My own sister. My own blood. My one. And only. Sibling. TRIED TO FUCKING MURDER ME.
Daisy (giggle): pff
Belle: …
Daisy (laughing): MHIAHDJQOJDBWIBDQMDLAPSIRNNQKZOXHEBALOFU4BWOF
Belle (furious): YOU TRAITOR
update Belle (angry) center [animation="Tada" length="0.6" wait="true"]
Daisy (laugh/cry): AHAHAHHAHhahajjsjhahasjsjsjs hic apskwnka hic hahhhh…
Belle (pin): I should kill you right now.
Daisy (nervous): hm—
Belle (noticing): ...
update Belle (neutral) right [move_time="0.5"]
Belle: Sorry.
Daisy (softer): It's fine, sorry for—
Belle: The murder? Yeah.
Daisy (meek): Let's… get going.

[end_timeline]
""",

    "ch1_scene3_supermarket.dtl": """# ch1_scene3_supermarket.dtl
label start

[background path="res://backgrounds/supermarket.png" fade="1.0"]
join Belle (bored) right
join Daisy (neutral) left

Belle (groaning): Ughnn! How long is this gonna take?
Daisy: There's a lot of prices I need to compare and brands I need to research, so probably the whole day.
Belle (exasperated): The whole day?! Who spends that much time in a shitty supermarket?!
Daisy: From now on, you.
Belle (protesting): You can't do this to me, Days. There are worse torture methods than this.
Daisy (losing temper): Belle… how about you just shut up and just let me work? Besides, after I get these sheets done, it'll be a whole lot quicker.
Belle (curious): Sheets?! Like, those excel shit and all? Glad to know you're still the same smart ass of before.
Daisy: Being a 'smart ass' is literally my job, the best a high school degree could offer for now.
Daisy: What if instead of being such a brat, you could help me with those damn groceries that being a smart ass pays, huh?
Belle (muttering): At least you have a high school degree.
Daisy (startled): … what?
Belle (defiant): 'What' what, big brain? Why are you asking if you are 'The all-knowing amazing smart ass'?
Daisy: You… dropped out of school?
Belle (careless): Oh… I may have… forgotten to tell you this.
Daisy: How can you even forget— Ugh, nevermind…
Belle: Relax, sis! It's no biggie!
Daisy (silent): …
Belle: Days?
Daisy (sad): Why? You've always been so skilled.
Belle (hesitant): I… Uhm… I just… couldn't do it, you know? It was just… too much, I guess.
Daisy: …
Belle (hurt): It's not like you'd understand. You've always been the smart one, not me.
Daisy: …
Belle (angry): Stop looking at me like that! Don't even start that bullshit.
Daisy: But I'm not… I just… Ugh! Forget it… let's just get back to it.
Belle: Let me guess, you're thinking just how you are so much better than me.
Daisy (defensive): What? I'm not!
Belle (shouting): Then stop looking at me like that!
Daisy (shouting back): Like. What?!
Belle (turning away): …Nothing. You're right, let's just get back to it already. I don't want to spend the whole night here either.
Daisy (quiet): …
Belle: …
Daisy: …I'm sorry.
Belle (soft): It's okay…
Daisy: …
Belle: …

[end_timeline]
""",

    "ch1_scene4_home_breakdown.dtl": """# ch1_scene4_home_breakdown.dtl
label start

[background path="res://backgrounds/daisy_apartment.png" fade="1.0"]
join Daisy (tired) left
join Belle (tired) right

Daisy (exhausted): Huf… Huf… Could you please… stow the groceries? I need to get today's work done.
Belle (breathless): Sure, sis… just… give me a moment… to catch my breath…
Daisy: Killer slope, right? That's why I have everything delivered…
Belle (sarcastic): Didn't know you were such a snob now.
Daisy: Not anymore, apparently.
Belle: …
Daisy: Just… tidy up the place for me, please.

update Daisy (leaving) left [move_time="0.5"]
leave Daisy

Narrator: Ugh… What the fuck am I doing?! I spent so much time missing her and now that she's here I'm treating her like she's disposable.
Narrator: She's probably suffered enough already. I can't be like them… I need to be different… I need to be better… for her…
Narrator: Fuck… there's so much work I need to do… I spent the last days helping her and couldn't get any of my shit done. I'll think about a proper apology to her later.
Narrator: (Some time passes) UGH! I CAN'T FUCKING CONCENTRATE!!! What do I do? What do I do…?
Narrator: Hmm… I guess I can try to… relax a little…

[background path="res://backgrounds/daisy_bedroom_night.png" fade="0.8"]
join Daisy (blushing) center

Daisy (thinking): It's been weeks since I last used one of these… It's weird doing this with someone else at my house but… I don't mind if it's her… Hmm… so tight…
Daisy (moan): ah…
Narrator: I hope she doesn't hear me… It's been so long since I've felt this warm…
Daisy (moan): Mmhh…
Narrator: Fuck! It's so good… why do I feel this way…? Is it because of… oh no. No, no, no, no, no, no, no, no, no. Not fucking doing this.
Daisy (crying softly): Fuck! What the actual FUCK is wrong with me…
Narrator: Fuck… I hate this so much. I don't want to ruin everything… I don't want to… be like him… I don't want to… I don't want to… I don't want to…
Daisy (sleeping): ...

[end_timeline]
""",

    "ch1_scene5_morning_pasta.dtl": """# ch1_scene5_morning_pasta.dtl
label start

[background path="res://backgrounds/daisy_apartment_morning.png" fade="1.0"]
join Daisy (drowsy) left

Belle (off-screen): *Knock Knock* Days? You alive in there? You forgot to eat yesterday! I made you breakfast, get out of there!
Daisy (drowsy): Huh… Oh, okay! I'll get there, just let me… go to the bathroom first.
Belle: Don't linger too much, sleeping beauty!

Narrator: Did she… Did she hear me yesterday? By God, I hope not. Ugh, I reek of lube. If I get to the bathroom fast enough, she won't even know…

join Belle (playful) right

Daisy (surprised): AH!
Belle (laughing): Ha ha! Don't be such a scaredy cat!
Daisy (startled): Y-YOU JUMPED ME!!
Belle: No excuses! I'll get your plate, darling!
Daisy (sniffing): P-pancakes? Woah, it smells really nice, Belle!
Belle (proud): What can I say? I'm the best!
Daisy (happy): Hmm, so tasty too! They're so fluffy!
Daisy (impressed): You really tidied up the place, huh?
Belle (softly): Yeah, I guess I wanted to cheer you up!
Daisy: C-cheer me up?
Belle (sheepish): … I heard you crying yesterday. Figured it was my fault, so… this is my apology.
Daisy: Apology? For what?
Belle: For fucking with your routine. For complaining so much. For teasing you so much. For… everything, I guess. I haven't been a good sister to you.
Daisy (touched): Oh, Belle… you're doing great. Me crying wasn't your fault, okay? I was just… stressed with… work.
Belle (gentle): Days, you're a horrible liar. Look, I won't pry. Think of this as a thank you for… you know, letting me live with you and all.
Daisy: Belle, it's okay. You did nothing wrong. Could you just… uhm, let me take a shower real quick?
Belle: Oh, right, sorry haha! I'll leave you be!

[background path="res://backgrounds/bathroom.png" fade="0.8"]
update Daisy (sad) center

Daisy (to self): … Fuck. What the hell is wrong with me… I really need to bathe…

[background path="res://backgrounds/daisy_apartment.png" fade="1.0"]
join Daisy (fresh) left

Belle (cooking): (Sniff) Girl, what you cooking, it smells so– WHY'S THE DOOR OPEN?!
Daisy (panicked): Relax, babygirl, I just needed some air. It was really stuffy in here without a single window, so I made one.
Daisy (rushing): There's a window in the bathroom!
Belle (teasing): Which was somehow occupied, wasn't it?
Daisy (slamming door): Huf… Huf… I hate… leaving it open. I feel exposed!
Belle: Fine, fine. No more door opening. Who would've thought you'd be such a scaredy cat that even sunlight scares you.
Belle: That explains why you're so pale now, we used to be the same color, you know!
Daisy (grumpy): Stop lecturing me!
Belle: Stop being so lecturable! Lunch is almost ready.
Daisy: It smells nice. What you cooking?
Belle: Just the good ol' pasta recipe mom used to make. I had to add some extra spices for good measure. You know how bad of a cook she used to be.
Daisy: I remember it well… Hm…
Belle: Hm? Why the long face?
Daisy (hesitant): Uhm, it's just, now that you mentioned… can I ask you something? About our parents…
Belle (wary): What about them?
Daisy: Did our parents do anything to you?
Belle: What do you mean?
Daisy: To make you leave, I mean. Did they hurt you?
Belle (thinking): If they hurt me? Hm… No, they didn't. They were pretty normal with me.
Daisy: You sure? They're not known for being good at parenting at all.
Belle: Being bad at parenting is still their normal. I guess they were a little more overprotective of me, you know… so I wouldn't turn out like you.
Daisy: Then… why did you leave?
Belle (bitter): … I never forgave them for what they did to you.
Daisy: I see…
Belle: What?
Daisy: …Hm?
Belle: You clearly have something to say, don't you?
Daisy: Belle, let's just change the subject.
Belle (accusing): That face again…
Daisy (pleading): Isabelle, please, listen to me.
Belle (angry): No, you listen! You're thinking that I'm a moron, aren't you?! You always think you're better than me. You're always the one being praised. Always the best sibling.
Daisy: …
Belle (shouting): You know how they talked about you when you were gone? Like you were their most prized possession. Like you were their perfect son. Like you had so much potential and yet you threw it all away to become a fucking tranny.
Daisy (quiet): …
Belle: You know how it feels to never be chosen? To never be acknowledged? You fucking don't!
Daisy: Belle…
Belle: You had everything I ever wanted and you WASTED IT!

[audio path="res://audio/sfx/slam.wav"]

Daisy: Belle!
Belle (screaming): WHAT?!
Daisy (soft): The pasta… You burned it…
Belle (deflated): … Fuck me, I guess. Not even good enough for a goddamned pasta.
Daisy: …
Belle: …
Daisy: I'm sorry.
Belle (sarcastic): You sure are… now go eat your burned pasta. It was… made with love!
Daisy (teary): I'm sorry…
Belle (sighing): Come here, you crybaby.
update Belle center [move_time="0.4"]
Daisy (sobbing): I'm sorry.
Belle (comforting): Hush, hush now. Don't bother with it. Just don't distract me next time.
Daisy: I'm sorry.
Belle: It's okay. It's okay. It's all gonna be okay…

set {PastaBurned} = true

[end_timeline]
""",

    "ch1_scene6_abby_chat.dtl": """# ch1_scene6_abby_chat.dtl
label start

[background path="res://backgrounds/daisy_bedroom.png" fade="1.0"]
leave Belle
join Daisy (neutral) left

Daisy (typing): *tec *tec *tec Mission… tec. Accomplished! Haaaaaaaah… it's done! Finally! I'm free….

Narrator: I want to sleep the whole weekend… Damn, I'm starving… Belle isn't cooking shit. All she does all day is doomscroll and complain.
Narrator: I'm tired… I don't really know what to do. Is she still mad at me for the pasta thing? Ugh… thinking hurts… sometimes I just wish I had a mommy older gf to tell me what to do.
Narrator: She'd probably say to try to distract my mind so I wouldn't be stuck in my own thoughts. Yeah, I should probably play something.

[audio path="res://audio/sfx/computer_beep.wav"]

Narrator: Huh? Did I forget to fill up a form – Abby?!

join Abby (phone) right [animation="Fade Up" length="0.3" wait="true"]

Abby: "Hey girl, u good? You always boot up that game when you're messed up."
Daisy: "U really do know me huh Abs. You free rn?"
Abby: "Kinda? I have a date coming over in like, 30s? But I'm free until there."
Daisy: "Leme guess[br]Another boymoder you found on grindr?"
Abby: "Aww u know me so well, D! Now spill the tea!"
Daisy: "My sister has come over to live with me. She was homeless for a while and didn't have anywhere else to go."
Abby: "Wow… That's harsh. Is she okay?"
Daisy: "I think so? I don't know, actually.[br]The thing is[br]I think I'm doing something really wrong[br]I don't know what to do."
Abby: "Girl, breathe.[br]What could you possibly be doing that would be so wrong?"
Daisy: "I think I might be grooming her…"
Abby: "Woah, woah, woah.[br]Wait a second, D. What the fuck did you do?"
Daisy: "I don't know! It's just… I think I'm attracted to her…"
Abby: "You?[br]Attracted to someone?[br]Weren't you ace aro or something?"
Daisy: "I AM![br]I don't know why I'm feeling like this.[br]I hate it. I hate it so much."
Abby: "Daisy, first of all, how old is she?"
Daisy: "18[br]but that's beyond the point."
Abby: "Then you're not grooming her?[br]You're both grown ass woman."
Daisy: "idk its just[br]complicated[br]hm[br]fuck i feel bad abby"
Abby: "You are NOT like him.[br]You know that, right?"
Daisy: "But what if I'm making her feel this way? What if she's scared of me?"
Abby: "You forget you are as much of a victim as her, D.[br]You've both gone through that shit.[br]If there's someone in the entire world who understands you best, it's her."
Daisy: "I… I did something."
Abby: "Elaborate."
Daisy: "I was stressed with work and couldn't concentrate, so I tried to…[br]You know… destress"
Abby: "And what happened?"
Daisy: "I started to feel good[br]too good…[br]like I could[br]get there, yk?"
Abby: "Wait, that's good![br]????[br]You like[br]Never there"
Daisy (sobbing): "It felt like last time"
Abby: "oh[br]poor girl"
Daisy: "I think it's because I felt like she could hear me.[br]Fuck[br]I'm monster."
Abby: "D[br]listen to me[br]some people deal with shit in different ways okay?[br]You are NOT a monster[br]Freaky?[br]yea. we figured that together b4[br]but that's not a bad thing."
Daisy: "I hate that I liked it[br]I hate that it felt good.[br]I hate my body."
Abby: "C'mon, D, relax. It's okay. You're not doing anything wrong.[br]We aren't that different, you know[br]I'm a monster?"
Daisy: "No?"
Abby: "Yeah, cause in your logic, I 'groom' closeted t-girls so I can fuck their brains out and feel like I'm in control of when it happened while I was one.[br]Main difference I'm fucking consenting adults"
Daisy: "I don't want to[br]fuck anyone"
Abby: "D, I know your bottom dysphoria sucks[br]we already know that it doesn't mean you can't try other options, right?"
Daisy: "What is wrong with me…"
Abby: "Youre a pathetic bottom"
Daisy: "Abs."
Abby: "D, why don't you talk to her?"
Daisy: "NO FUCKING WAY.[br]???????"
Abby: "Is that really a bad idea?[br]Like I said[br]If there's someone who would understand you, it's her.[br]You shouldn't be afraid of her, she's your beloved lil sis!"
Daisy: "Don't call her like that…"
Abby: "Oh for fuck's sake[br]Daisy, you had all Volumes of Onimai.[br]You've always been into some freaky incest stuff.[br]I know what you are."
Daisy: "STOP STOP FOR THE LOVE OF GOD STOP TALKING."
Abby: "If you don't want to talk to her, what about you sneaking into her stuff and grabbing a used underwear![br]Like those really ass ecchi anime"
Daisy: "Sybau.[br]I'm blocking you forever.[br]Die"
Abby: "Just kidding just kidding lmao[br]I'll have to go now D.[br]Let's just say my… 'food'[br]has arrived."
Daisy: "..."
Abby: "And by 'food' I mean…[br]Lets just say haha"
Daisy: "YEA[br]I GOT IT"
Abby: "I'm Always here for you, princess.[br](except when I'm… eating)."
Daisy: "Fuck off.[br]I swear.[br]Im gonna do it this time"
Abby: "I'm not gonna fuck 'off' silly![br]I'm going to fuck a really pretty girltwink who wears hoodies 24/7!"
Daisy: "I really can't say that you're a chaser?"
Abby: "Yeah.[br]now go back to the robot mommy ASMRring in your ear how fat and plumpt you are."
Daisy: "I hate you."
Abby: "S2[br]Later lil sis enthusiast~"
Daisy: "… (logs off)"

Narrator: Perhaps… things will get better from now on.

[end_timeline]
""",

    "ch2_scene1_balcony.dtl": """# ch2_scene1_balcony.dtl
label start

[background path="res://backgrounds/balcony_night.png" fade="1.0"]
leave Abby
join Belle (neutral) left

Belle (smoking): What a week, huh…

Narrator: Really hard to sleep on a couch that feels like a trash bag full of fucking needles. How can an apartment so high up be so damn hot? There ain't even a good view from this bitchass house.
Narrator: How can Daisy even live here? I guess she doesn't even care. I bet all she does all day is sit her fat ass on that computer and jerk off to anime girls.
Narrator: No… I guess she doesn't. If she did I would have heard it by now with those paper walls.
Narrator: Maybe she's just a workaholic, huh… she's always been so competent with things. Always an +A student, always a perfect child, always polite, always well-behaved… and then… there was me.
Narrator: All I ever did was ruining her life. And now, here I am leeching off her. Eating her food, sleeping on her couch, shitting on her toilet, smoking on her balcony. All hers. Yet, I'm still here…
Narrator: Why hasn't she kicked me out yet? I don't understand why she's all lovey dovey with me after all I've done.
Narrator: Maybe she does love me… pff nah I doubt it. She probably just pity the shit out of me. She doesn't give a fuck about me, she just doesn't want to feel guilty.
Narrator: Maybe it'd be better if I just jumped from this balcony and spared both of us the trouble…
Belle (laughing bitterly): pff hahaha HaHaHaHa! Ahh… as if I had that right…

[audio path="res://audio/sfx/door_creak.wav"]
join Daisy (sleepy) right

Daisy: Belle? You there?
Belle (dry): Don't you have work tomorrow, dear sister?
Daisy: I-I heard you laughing and… are you smoking?
Belle: (inhales) What do you think?
Daisy: Since when do you… No, no, nevermind. I'll leave you be. Good night, sis.
Belle: …night.

Narrator: So well‑behaved… as always. sigh… She must despise me. She could've been so much. I ripped it all from her. Broke her and left her in pieces! It's all my fucking fault!
Narrator: I haven't changed one bit, have I…? I'm still the same stupid kid that fell in love with him… I hate this… I hate this so much… I don't want to ruin her again… I don't want to… I don't want to… I don't want to…
Narrator: … (Belle stops sobbing, starts disassociating)
Narrator: Sigh… It doesn't really matter, does it? I just need to… buy some time… until I can find another place to crash. She hates you… like everybody else… like everybody… else…
Narrator: … Ugh… Fuck, what was that all about! I really shouldn't trust my own thoughts past 9:00 PM… I need some sleep.

[end_timeline]
""",

    "ch2_scene2_tv_confrontation.dtl": """# ch2_scene2_tv_confrontation.dtl
label start

[background path="res://backgrounds/daisy_apartment.png" fade="1.0"]
leave Daisy
join Belle (bored) center

Narrator: click click Boring… boring… boring. Ugh! Election period is so ass! All channels are filled with the same bullshit! I'll go out for a smoke…

join Daisy (nervous) left

Daisy: Uhm, Good afternoon, sis! How you feeling?
Belle (flat): … fine, I guess.
Daisy: Good. Good. That's great! Uhm… look I'm not good with this, but… can we talk?
Belle: … sure.

Narrator: (Disassociating) There it is. She's kicking me out. Not even "Mrs. Perfect" could stand me.
Narrator: I guess mom and pops were right when they said I will never amount to anything. I'm just a worthless bitch with a pretty body. That's all I am. I don't know how to be anything else…
Narrator: I may be cursed… cursed to hurt everyone I ever loved. Cursed to destroy every relationship I've built. Cursed to burn every single bridge I've ever crossed… I'm despicable.
Narrator: The only good thing I have is this body. So… If I have to use it to get what I want, then so be it. I'll use it. I'll survive.
Narrator: I just need a couple more days, right? Just a couple more days. A couple more days. A couple more days. A couple more days…

update Daisy center [move_time="0.6"]

Daisy: Look, when I said you could live here, I told you only had to follow some conditions: you'd cook and you'd tidy your things up.
Daisy: Since the pasta thing, you haven't cooked at all. All we've been eating has been pre‑heated food and other junk that I can't afford to keep paying.
Daisy: The living room is also filled with empty snacks, dirty clothes and all sorts of trash. Your trash.
Daisy: You haven't even been taking care of your own hygiene, Belle. You rarely bathe and I've never even seen your toothbrush in the bathroom!
Daisy: I'm just… worried about you, about us. I really want us to work. I'm not blaming you either, I just want to understand you, to help you. I want you to help me help you.
Daisy: Are you… listening to me? Belle…? Belle, what are you doing? Belle…? Belle…?! Belle, stop this… please… Belle… Ah!

update Belle (close) center [move_time="0.3" wait="true"]

Daisy (moan): Ah!
Belle (snapping back): …
Daisy (teary): …
Belle: …

[audio path="res://audio/music/christian_song.wav"]

Narrator: That's… my song… Oh… It's him…
Narrator: A cheerful man in cleric attire appears on the TV. He's proudly announcing his candidacy while a choir of children sing in the background. He approaches the kids and gives them all a big hug.
Narrator: "We need to protect our children from the common enemy," he says.
Narrator: He has… a scar… from that day… it's my fault. my fault. my fault. my fault. my fault. my fault. my fault. my fault. my fault. my fault.

[audio stop="true"]

Daisy (rage): …
Belle: …
Daisy (quiet): I think… we should go outside a little – get some air, you know?

[end_timeline]
""",

    "ch2_scene3_park_confession.dtl": """# ch2_scene3_park_confession.dtl
label start

[background path="res://backgrounds/park.png" fade="1.0"]
join Daisy (sad) left
join Belle (downcast) right

Daisy: …
Belle: …
Daisy: …
Belle (murmur): I'm… sorry…
Daisy (tender): Belle… you know I love you, right?
Belle: …
Daisy: After we got… separated… I really don't know what happened to you, but I know something happened. I need to know. I want to help you. You're the only thing I have left. I can't lose you too.
Belle (shivering): … I‑I… I don't– I– I'm sorry… I–
Daisy: Belle, it's okay… You don't need to apologize. I'm here for you, just… help me understand you. I may be the only one who truly can.
Belle (breaking down): I… I missed you – So. Much. I couldn't stop thinking about you. That I lost you and it was my fault. If I had spoken out for you–
Daisy (urgent): Belle! Don't… don't ever say that again. You're not to blame for what happened. …It was my fault – I couldn't protect you.
Belle (shouting): You don't understand shit!!!
Daisy: Then help me! Help me understand you…
Belle (crying): I‑I… I knew what I was doing…
Daisy: Isabelle, you were eleven! What the FUCK are you talking about?!
Belle (desperate): I KNEW!!! I knew…
Daisy: Belle…
Belle: I knew what those extra singing lessons were. I knew what he wanted to do to me. I knew how he touched me was wrong. I knew I should have told someone. I knew every. single. thing.
Daisy: Belle…
Belle (sobbing): I… I‑I liked it. I liked being the favourite for once. I liked feeling special. I liked feeling desired. I‑I loved it… I loved… him.
Daisy (crying): Oh… God… no… Belle that's not…
Belle: IT'S MY FAULT!!! HE WASN'T FORCING HIMSELF ONTO ME, I WANTED IT!!!
Belle: You don't know what it's like… he was the first one to tell me I was special… I… I miss it. I miss… him.
Daisy (wailing): fuck… Belle… I'm so fucking sorry…
Belle: If you hadn't barged in that day… If you hadn't been such a nosy bitch, you… you'd have been fine. No one would have known you were a girl… You'd still have your paid scholarship… You'd still have a bright future ahead of you.
Belle: But no… no… NO… YOU HAD TO FUCKING HIT HIS HEAD WITH THAT GLASS, HADN'T YOU?! YOU HAD TO LET YOUR WEAK FAT ASS BE RAPED!!! YOU HAD TO MAKE OUR ENTIRE HOMETOWN THINK YOU WERE GROOMING ME!!!
Belle: YOU DESTROYED YOUR ENTIRE FUTURE AND FOR WHAT?!?! HUH?!?! FOR NOTHING!!! … for nothing…
Daisy (screaming): IT WASN'T FOR NOTHING!!! IT WAS FOR YOU!!! ALL I EVER DID WAS FOR YOU!!!
Daisy: … you weren't just special, you were everything to me. I was in pain for months. I bled every single fucking day. No one believed me… No one… just you… and they took you away from me!!! I missed you so much…
Belle (softening): Day… You're a fucking moron…
Daisy (weary): I know… do you know… what my plan was?
Belle: What plan?
Daisy: After I graduated high‑school, I planned to ask you to live with me. I always wanted us to be together. It wouldn't be easy, for sure, but… I wanted to take you away from our parents.
Daisy: I wanted you to grow up in a household filled with love – not whatever our parents expected from us. That's why I was always trying so hard, you know? I wanted to be good enough… for both of us… so you wouldn't have to suffer anymore.
Belle (voice breaking): I… I don't believe it… I‑I– Fuck… I hate you so much…
Daisy (soft smile): Don't hate your big sis, Belle… you know I really love you, right?
Belle (sobbing): I'm so, so sorry, Days… I‑I don't even know how to repay you, I… fuck, I–
Daisy (gentle): I just need you to cook, my beautiful Babybell… Just that. Leave the rest to me, okay?
Belle: It just feels so… unfair… I‑
Daisy: It is not! Listen to me, girl… It's okay. Let's go home, Belle. Our home. Why don't you cook us that pasta again? I swear I won't distract you this time.
Belle: (sob) Okay… I'll do my best.

[end_timeline]
""",

    "ch2_scene4_hill_assault.dtl": """# ch2_scene4_hill_assault.dtl
label start

[background path="res://backgrounds/hill_road.png" fade="1.0"]
update Daisy (tired) left
update Belle (tired) right

Belle (panting): Huff Huff… Going up is definitely harder… than going down…
Daisy: No shit, Sherlock… ha ha. We can take a break…
Belle: …
Daisy: What? Did I say something wrong?
Belle (smiling): You laughed! Daisy, you laughed! You never laugh! Ha hahaha!
Daisy (chuckling): What do you mean Huff… I never laugh?!
Belle: I told you before, Day. Resting bitch face! Hahahahaha!
Daisy: Yeah… I guess you're the only one who can make me laugh… Ha ha ha.

[audio path="res://audio/sfx/footsteps.wav"]
join RandomGuy1 (smirk) left
join RandomGuy2 (lewd) right

RandomGuy1: Slap Nice cake you have there, pretty!
Daisy (freezing): …
Belle (freezing): …
RandomGuy2: Own! Look at them, they're shy!
RandomGuy1: Why don't you two come with us so we can have some fun, huh? I'd love to see your sweaty ass bouncing on me!
RandomGuy2: Cat's got your tongues? Let me help you find it, sweety.
Belle (stiff): …
Daisy (furious): Take your filthy hands away from her!!!
RandomGuy1 (hugging Daisy): Oh! You talk, huh? I bet you have a nice pussy under that skirt – OH FUCK!! Get off of me!!!
RandomGuy1 (shoving Daisy): Urgh! What the fuck man, he has a cock! It's a fucking tranny!
RandomGuy2: Hah! You're such a fag!
RandomGuy1 (defensive): Wha‑ SHUT YOUR HOLE!!! How could I know a manfreak could have an ass like that?
RandomGuy2: You were the one enamored by a guy's ass! I'm telling everybody you like sissies, faggot.
RandomGuy1: Oh fuck off, how do you know the other bitch ain't a guy too?
RandomGuy2: No adam's apple, faggot. Her tits are rounder too! We can still have fun with her, you know.
Belle (silent): …
Daisy (whisper): Belle, at the 3, run…
Belle: …
RandomGuy1: Who allowed you to get up, huh? I should teach you a fucking lesson for lying to me.
Daisy: 1…
RandomGuy2: What?! You really trying to get some guy's ass? I always knew there was something wrong with you.
Daisy: 2…
RandomGuy1: Fuck off, man! Wanna fight? If he wanna pretend to be a woman so much, it's my right to show him what a real man is!
Daisy (shout): 3!

[background path="res://backgrounds/hill_road_blur.png" fade="0.2"]
leave RandomGuy1
leave RandomGuy2
update Daisy (running) left [move_time="0.2"]
update Belle (running) right [move_time="0.2"]

[background path="res://backgrounds/daisy_apartment.png" fade="0.5"]

Daisy (panting): Arf… Huf… Are you… okay?
Belle (heavy breath): ...
Daisy (sobbing): I'm… so sorry that happened…
Belle (distant): …
Daisy: Belle? Oh, Belle…
Belle (quiet): Daisy…?
Daisy: What baby?
Belle: It happened again…
Daisy: Belle, look at me, it's okay.
Belle: I froze…
Daisy (holding her): Belle! Look at me.
Belle (laughing hollowly): Heh, it's funny…
Daisy: What? What are you talking about? What is funny?
Belle: Heh! If you hadn't pulled me I'd just stay there. With them. He he he
Daisy (horrified): Oh… God! Please stop talking…
Belle: Pfff hahahaHaHa!!! What?! It's not like I'm wrong! The only difference is that I wouldn't have to just watch this time, right?
Daisy (breaking): I'm sorry… I‑I… can't… I can't do this right now. I need… to go to my room. I'm sorry…
Belle (manic laugh): HA HA HA HA HA Ha Ha ha ha ha… ha… …

[end_timeline]
""",

    "ch2_scene5_dark_thoughts.dtl": """# ch2_scene5_dark_thoughts.dtl
label start

[background path="res://backgrounds/daisy_apartment.png" fade="1.0"]
leave Daisy

Belle (alone): ...

Narrator: It's your fault, you know that, right? If you hadn't freaked out earlier, you'd both be nice and cozy. Better yet, if you had never come here in the first place, she wouldn't have to deal with your bullshit.
Narrator: Isabelle, you're a fucking disgrace. I bet you wish she'd just run away and let them have fun with you, don't you? I bet you wish they would teach you a lesson for being such a bad girl, don't you?
Narrator: I bet you wish they'd break you and leave you to bleed at the nearest dumpster, don't you? But no… She saved you once again. A dumb, innocent and weak little bunny that needs to be saved again and again and again.
Narrator: Because she loves you so much, right? She will grow tired of you. It may take a while, but someday, she will notice. She will notice how much of a dead weight you are.
Narrator: And when that day comes… you will be alone. And you know what happens after that? Another wolf will come. It will offer you food and a place to stay. It will give you its time and attention.
Narrator: But then… it will get hungry… it will devour you. Rip your flesh straight out of your bones. Pull your guts out of your belly. Dump your body in a yard full of petals.
Narrator: There's no salvation for you, little bunny. Just await for the time when the Bell tolls for thee. It will come as shortly as the length of your tail. You hear me, Isabelle?
Narrator: Even the air coming in and out of your lungs is wasted on a creature so futile and revolting. Not even your dismembered foot would be a sign of good luck.
Narrator: DO YOU HEAR ME, ISABELLE?! Let's play a game. Walk towards the drawer, grab the sharpest knife you can find. cover yourself head to toe with super sexy scars, right?
Narrator: That's what you want, right? That's what you ever wanted, right? Catch the damned rabbit, Isabelle. C A T C H ! ! !

join Daisy (concerned) left [move_time="0.5"]

Daisy (concerned): Belle…? What are you doing?
Belle (dazed): … Huh? I‑I was… just… Cooking!
Daisy (relieved): Oh… Have you started yet? I was gonna ask if you wanted to have something delivered…
Belle: N…No, I haven't started it yet.
Daisy: Do you want to have something in particular? I figured we could afford some take out once in a while.
Belle: Whatever you want… I'm… not really hungry.
Daisy (encouraging): C'mon, Belle. We both had a shitty day. Let's just try to forget it for once and… you know, get stuffed. What do you think?
Belle: …okay.
Daisy (softly): And… I'm sorry for leaving you alone. I just… needed some time to chill out my head and fill the police reports and–
Belle: It's okay. Let's just forget about it, right?
Daisy: Okay… I'll order us some sushi. You like sushi, right?
Belle (faint smile): Yeah…
Daisy: Perfect. I'll be in my room finishing some work, but I'll leave my door open this time, okay? Call me if you need anything.
Belle (quiet): Ok…

[end_timeline]
""",
}

# -------------------- Write Files --------------------
def main():
    # Create output directory if it doesn't exist
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"Created directory: {OUTPUT_DIR}")

    for filename, content in FILES.items():
        filepath = os.path.join(OUTPUT_DIR, filename)
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(content)
        print(f"Overwrote: {filepath}")

    print("\nAll timeline files have been updated successfully.")
    print("\nRemember to declare these variables in Dialogic's Variables tab:")
    print("  - BelleArrived (Boolean, default false)")
    print("  - BelleLivingHere (Boolean, default false)")
    print("  - PastaBurned (Boolean, default false)")

if __name__ == "__main__":
    main()