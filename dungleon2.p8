pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
function _init()
	debug=false
	cursor=1
	aid=false
	first_aid=true
	guess={}
	check=false
	hearts=3
	hardmode=true
	plays=0
	wins=0
	wins_hard=0
	streak=0
	spoils_heroes=0
	spoils_monsters=0
	spoils_treasure=0

	state="play"
	-- intro
	-- menu
	-- play
	-- lose - 20 guesses
	-- win - correct solution

	solution={"archer",
			"warrior",
			"blade orc",
			"axe orc",
			"chest"}
	chars={
			{
				name="warrior",
				type="hero",
				spr=1,
				spoil="hero",
				min=1,
				max=1,
				code=1,
				palt=14,
				result="none"
			},
			{
				name="archer",
				type="hero",
				spr=2,
				spoil="hero",
				min=1,
				max=1,
				code=1,
				palt=14,
				result="none"
			},
			{
				name="mage",
				type="hero",
				spr=3,
				spoil="hero",
				min=1,
				max=1,
				code=1,
				palt=14,
				result="none"
			},
			{
				name="bat",
				type="monster",
				spr=6,
				spoil="monster",
				min=2,
				max=2,
				code=2,
				palt=14,
				result="none"
			},
			{
				name="spider",
				type="monster",
				spr=7,
				spoil="monster",
				min=3,
				max=3,
				code=2,
				palt=14,
				result="none"
			},
			{
				name="blade orc",
				type="monster",
				spr=8,
				spoil="monster",
				min=2,
				max=1,
				code=2,
				palt=10,
				result="none"
			},
			{
				name="axe orc",
				type="monster",
				spr=9,
				spoil="monster",
				min=2,
				max=1,
				code=2,
				palt=10,
				result="none"
			},
			{
				name="skeleton",
				type="monster",
				spr=10,
				spoil="monster",
				min=1,
				max=4,
				code=2,
				palt=10,
				result="none"
			},
			{
				name="villager",
				type="npc",
				spr=4,
				spoil="none",
				min=1,
				max=1,
				code=1,
				palt=14,
				result="none"
			},
			{
				name="king",
				type="npc",
				spr=5,
				spoil="none",
				min=1,
				max=1,
				code=1,
				palt=14,
				result="none"
			},
			{
				name="zombie",
				type="other",
				spr=22,
				spoil="monster",
				min=1,
				max=0,
				code=3,
				palt=10,
				result="none"
			},
			{
				name="thief",
				type="monster",
				spr=23,
				spoil="monster",
				min=1,
				max=1,
				code=1,
				palt=11,
				result="none"
			},
			{
				name="wizard",
				type="monster",
				spr=24,
				spoil="monster",
				min=1,
				max=1,
				code=5,
				palt=11,
				result="none"
			},
			{
				name="necromancer",
				type="monster",
				spr=25,
				spoil="monster",
				min=1,
				max=1,
				code=2,
				palt=14,
				result="none"
			},
			{
				name="wand",
				type="aid",
				spr=16,
				spoil="none",
				min=1,
				max=1,
				code=-1,
				palt=11,
				result="no aid"
			},
			{
				name="coins",
				type="loot",
				spr=17,
				spoil="loot",
				min=2,
				max=3,
				code=0,
				palt=14,
				result="none"
			},
			{
				name="chest",
				type="loot",
				spr=18,
				spoil="loot",
				min=1,
				max=3,
				code=0,
				palt=14,
				result="none"
			},
			{
				name="relic",
				type="loot",
				spr=19,
				spoil="loot",
				min=1,
				max=1,
				code=5,
				palt=11,
				result="none"
			},
			{
				name="frog",
				type="other",
				spr=20,
				spoil="none",
				min=1,
				max=0,
				code=3,
				palt=14,
				result="none"
			},
			{
				name="dragon",
				type="monster",
				spr=21,
				spoil="monster",
				min=1,
				max=1,
				code=2,
				palt=14,
				result="none"
			}
		}
	
		timers={}
		--length
		--frames
		--current
		--tag
end

function _update()
	tnum=#timers
	for t=tnum,1,-1 do
		timers[t].current+=1
		if timers[t].current>timers[t].length then
			del(timers,timers[t])
		end
	end
	if state=="play" then
		play_controls()
	elseif state=="lose" or state=="win" then
		if btn(🅾️) and btn(❎) then
			_init()
		end
	end
end

function _draw()
	cls()
	-- grid lines
	if debug then
		for i=0,127,8 do
			line(i,0,i,127,10)
		end
		rect(0,0,127,127,11)
	end
	if state=="play" then
		board()
		characters()
		guesses()
	elseif state=="win" then
		board()
		characters()
		guesses()
		transition("gOT IT!",3)
	elseif state=="lose" then
		print("nOT THIS TIME...")
		transition("nOT THIS TIME...",14)
	end

	timer_draw_actions()
end

function play_controls()
	if btnp(➡️) then 
		if cursor==20 and aid then
			cursor=15
		elseif cursor==20 then
			cursor=16
		elseif cursor==14 then
			cursor=9
		elseif cursor==8 then
			cursor=1
		elseif cursor < #chars then
			cursor+=1
		else 
			cursor=1
		end
	end
	if btnp(⬅️) then 
		if cursor==9 then
			cursor=14
		elseif cursor==16 and aid==false then
			cursor=20
		elseif cursor > 1 then
			cursor-=1
		else 
			cursor=8
		end
	end
	if btnp(⬆️) then
		if cursor==1 or cursor==8 then
			--nothing
		elseif cursor==2 then 
			if aid then
				cursor=15
			else
				cursor=9
			end
		elseif cursor>2 and cursor<8 then
			cursor=13+cursor
		elseif cursor>8 and cursor<15 then
			cursor-=7
		elseif cursor>15 and cursor<21 then
			cursor-=6
		end
	end
	if btnp(⬇️) then
		if cursor==1 or cursor==8 then
			--nothing
		elseif cursor>1 and cursor<8 then
			cursor+=7
		elseif cursor==9 then
			if aid then
				cursor=15
			else
				cursor=2
			end
		elseif cursor>9 and cursor<15 then
			cursor+=6
		elseif cursor>14 and cursor<21 then
			cursor=cursor-13
		end
	end
	if btnp(🅾️) then
		--add char to current spot
		tempchars=deepcopy(chars)
		add(guess,tempchars[cursor])
		guess[#guess].result='guess'
		check=true
		if #guess%5==0 then
			check_guesses(#guess/5-1)
		end
		
		if chars[cursor].type=="hero" or chars[cursor].type=="npc" or chars[cursor].name=="thief" then
			dir="bump right"
		else
			dir="bump left"
		end
		add(timers,{length=1,speed=1,current=0,tag=dir})
		add(timers,{length=2,speed=1,current=0,tag="button press"})
		if #guess == 30 then
			state="lose"
		end
	elseif btnp(❎) then
		--delete last placed char
		if #guess%5 > 0 then
			del(guess,guess[#guess])
		end
	end
end

function transition(title,col)
	-- fillp(0b0011001111001100)
	fillp(▒)
	rectfill(0,0,127,127,5)
	fillp()
	rectfill(20,6,107,101,0)
	print(title,52,11,col)
	-- plays=0
	-- wins=0
	-- wins_hard=0
	-- streak=0
	-- spoils_heroes=0
	-- spoils_monsters=0
	-- spoils_treasure=0
	print(plays,34,43,7)
	print(wins,62,43,7)
	print(streak,90,43,7)
	print('PLAYS',26,50,6)
	print('WINS',56,50,6)
	print('STREAK',80,50,6)

	print('SPOILS',52,60,6)
	print(spoils_heroes,34,68,7)
	print(spoils_monsters,62,68,7)
	print(spoils_treasure,90,68,7)
	print('PLAYS',26,50,6)
	-- spr(28,25,68)
	-- spr(44,54,68)
	-- spr(60,82,68)
	spr(28,32,76)
	spr(44,59,76)
	spr(60,87,76)
	
	pos=1
	for g=#guess-4,#guess do
		shspr(guess[g].spr,21+pos*13,22,guess[g].palt,highlight,'right','deep')
		pos+=1
	end
end

function shspr(s,x,y,pl,hl,m,bg)
	-- shadow sprite
	-- s = sprite number
	-- x = x position
	-- y = y position
	-- pl = transparency colour
	-- hl = highlight
	-- m = match
	-- bg = background style

	if highlight then
		if m=="none" then
			spr(168,x-2,y-2)
			spr(169,x+6,y-2)
			spr(184,x-2,y+6)
			spr(185,x+6,y+6)
		elseif m=="wrong" then
			spr(170,x-2,y-2)
			spr(171,x+6,y-2)
			spr(186,x-2,y+6)
			spr(187,x+6,y+6)
		elseif m=="close" then
			spr(172,x-2,y-2)
			spr(173,x+6,y-2)
			spr(188,x-2,y+6)
			spr(189,x+6,y+6)
		elseif m=="right" then
			spr(174,x-2,y-2)
			spr(175,x+6,y-2)
			spr(190,x-2,y+6)
			spr(191,x+6,y+6)
		elseif m=="yes aid" then
			spr(140,x-2,y-2)
			spr(141,x+6,y-2)
			spr(156,x-2,y+6)
			spr(157,x+6,y+6)
		end
	else
		if bg == "flat" then
			if m=="none" then
				spr(160,x-2,y-2)
				spr(161,x+6,y-2)
				spr(176,x-2,y+6)
				spr(177,x+6,y+6)
			elseif m=="guess" then
				spr(128,x-2,y-2)
				spr(129,x+6,y-2)
				spr(144,x-2,y+6)
				spr(145,x+6,y+6)
			elseif m=="wrong" then
				spr(162,x-2,y-2)
				spr(163,x+6,y-2)
				spr(178,x-2,y+6)
				spr(179,x+6,y+6)
			elseif m=="close" then
				spr(164,x-2,y-2)
				spr(165,x+6,y-2)
				spr(180,x-2,y+6)
				spr(181,x+6,y+6)
			elseif m=="right" then
				spr(166,x-2,y-2)
				spr(167,x+6,y-2)
				spr(182,x-2,y+6)
				spr(183,x+6,y+6)
			elseif m=="no aid" then
				spr(142,x-2,y-2)
				spr(143,x+6,y-2)
				spr(158,x-2,y+6)
				spr(159,x+6,y+6)
			elseif m=="yes aid" then
				spr(138,x-2,y-2)
				spr(139,x+6,y-2)
				spr(154,x-2,y+6)
				spr(155,x+6,y+6)
			end
		else
			if m=="wrong" then
				spr(130,x-2,y-2)
				spr(131,x+6,y-2)
				spr(146,x-2,y+6)
				spr(147,x+6,y+6)
			elseif m=="close" then
				spr(132,x-2,y-2)
				spr(133,x+6,y-2)
				spr(148,x-2,y+6)
				spr(149,x+6,y+6)
			elseif m=="right" then
				spr(134,x-2,y-2)
				spr(135,x+6,y-2)
				spr(150,x-2,y+6)
				spr(151,x+6,y+6)
			end
		end
	end

	for i=0,15 do
		pal(i,0)
	end
	palt(0,false)
	palt(pl,true)

	spr(s,x-1,y)
	spr(s,x,y-1)
	spr(s,x,y+1)	
	spr(s,x+1,y)
	
	pal()
	palt(0,false)
	palt(pl,true)
	spr(s,x,y)
	palt()
end

function board()
	bx=13
	by=13
	of=32
	print("DUNGLEON",32,0,7)
	print("L",48,0,14)
	--hearts [optimise]
	if hearts==3 then
		spr(12,74,1)
		spr(12,80,1)
		spr(12,86,1)
	elseif hearts>=2 then
		spr(12,74,1)
		spr(12,80,1)
		if (hearts==2.5) spr(13,86,1)
	elseif hearts>=1 then
		spr(12,74,1)
		if (hearts==1.5) spr(13,80,1)
	elseif hearts==0.5 then
		spr(13,74,1)
	end
	--hard mode gem
	if (hardmode) spr(14,92,1)
	
	for x=0,4 do
		for y=0,5 do
			sx=bx*x
			sy=by*y
			result="none"
			-- backgrounds based on guesses
			if result=="none" then
				s1=128
				s2=144
			elseif result=="wrong" then
				s1=130
				s2=146
			elseif result=="close" then
				s1=132
				s2=148
			elseif result=="right" then
				s1=134
				s2=150
			end
			spr(s1,of+sx,7+sy)
			spr(s1+1,of+sx+8,7+sy)
			spr(s2,of+sx,7+sy+8)
			spr(s2+1,of+sx+8,7+sy+8)
		end
	end
end

function characters()
	for i=1,#chars do
		if cursor == i then
			highlight=true
		else
			highlight=false
		end
		if i>14 then
			shspr(chars[i].spr,2+13*(i-13),114,chars[i].palt,highlight,chars[i].result,'flat')
		elseif i>8 then
			shspr(chars[i].spr,2+13*(i-7),101,chars[i].palt,highlight,chars[i].result,'flat')
		else
			shspr(chars[i].spr,2+13*i,88,chars[i].palt,highlight,chars[i].result,'flat')
		end
	end
end

function guesses()
	newline=0
	offx=0
	if #guess > 0 then
		for i=1,#guess do
			shspr(guess[i].spr,21+13*(i-newline*5),9+13*newline,guess[i].palt,highlight,guess[i].result,'deep')
			if(i%5==0) newline+=1
		end
	end
end

function check_guesses(row)
	right=0
	wiz_check=0
	for g=1,5 do
		correct=0
		for s=1,5 do
			if guess[g+row*5].name==solution[s] then
				correct+=1
				if g!=s then
					guess[g+row*5].result='close'
				else	
					guess[g+row*5].result='right'
					right+=1
					wiz_check+=1
				end
			end
		end
		if correct==0 then
			guess[g+row*5].result='wrong'
		end
		for c=1,#chars do
			if guess[g+row*5].name==chars[c].name then
				chars[c].result=guess[g+row*5].result
			end
		end
	end
	if right==5 then
		state='win'
		wins+=1
		plays+=1
	end
	if (right==4 or wiz_check>0) and first_aid then
		aid=true
		first_aid=false
		for c=1,#chars do
			if chars[c].name=="wand" then
				chars[c].result="yes aid"
				chars[c].spr=32
			end
		end
	end
	check=false
	hearts-=0.5
end

function timer_draw_actions()
	for t=1,#timers do
		if timers[t].tag == "bump right" then
			camera(timers[t].current,0)
		elseif timers[t].tag == "bump left" then
			camera(-timers[t].current,0)
		else
			camera(0,0)
		end
		if timers[t].tag == "button press" then
			for i=1,#chars do
				if cursor == i then
					if i>14 then
						cx=2+13*(i-13)
						cy=114
					elseif i>8 then
						cx=2+13*(i-7)
						cy=101
					else
						cx=2+13*i
						cy=88
					end
				end
			end
			pal(5,0)
			spr(128,cx-2,cy-2)
			spr(129,cx+6,cy-2)
			spr(144,cx-2,cy+6)
			spr(145,cx+6,cy+6)
			pal()
		end
	end
end

-- utilities
function bprint(str,x,y,c1,c2)
	--print text with borders
	color(c2)
	print(str,x-1,y-1)
	print(str,x-1,y)
	print(str,x,y-1)
	print(str,x+1,y+1)
	print(str,x+1,y)
	print(str,x,y+1)

	print(str,x,y,c1)
end

function deepcopy(orig)
	--copy a list to another without keeping the references to the original
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
__gfx__
0000000077e8cccc88bee88eeaaaaeee7674444eeeae9eaedddeeccce22e2eeea2222a7aa22aa6a6aaaaaa6aeeeeeeee0e0800000e0000000b30000000000000
00000000e77c1c1ce8bbb008eb3888ee76766644eeaabaaed2eeecfeeee11122222222672222a6767777a65aeebbbeeeeee88000eee00000b7b3000000000000
00700700ee666666bb0bbb083b3aaaae777cfcf45644f44ed7ee7ceee22111e2a7e732677e7326760707a65aeb333bee0e8800000e8000003b33000000000000
00077000ea00b0be9070700883ac6caeed4ffffe65f1f1fe70d707ee27e7112e233332673e332646777aa659b333331e00800000008000000330000000000000
00077000ea777cccbb000bbd836666ee47ef77eeccf444fee7dd721e707072e223332a332332034aa77aa99ab300031e00000000000000000000000000000000
007007005a55571cdbb3b0088386777e4d44ff4ecc49994eeeec212ecccc2e2eaa111a3323324033aa22977ab333331e00000000000000000000000000000000
00000000ea777c1cbbb3b008e388767eed4aaa4ecc99999eecc2ee2ecece2e2e336667aaaa44403377a2277ae13331ee00000000000000000000000000000000
00000000ea2e2eceeddedd8e8388767eede4e4eecc99999eee2ee2ee8e82ee2e3377733a330aa04a77a22aaaee111eee00000000000000000000000000000000
bbb65bbbeeeeeeeeeee9999ebb99bbbbee7eee7eeeeeeeeeaaaaeeaabbbbbbbbbbbbb7bbbebebbeb00000000eeeeeeee00a77700000000000009900000000000
bb6505bbeeee99eeeee00009baabbbbbe7073707e88888deaa1ceeea111111bbb44b7e7beb777bbd00000000ee888eee45a1117000777700009aa90000000000
bbb65bbbeee9aa9eeef90009b99bbbbbe373337e8888788e1117cccab111111bb40447bbee8787be00000000e82228ee00accc00000706000049900000000000
bbd001bbeeee994eeed5aa09bbaabbbbee333333767688ee111cc7cab108e81b4000a0abee607bdb000000008202021e000000000076700009aa400000000000
bbbd1bbbe66e4aa9eef94409bae89babe9aaaab3787882ee1c8ccc1abb11ee1b47074a4bee5072be000000008220221e00000000000770000099000000000000
bbbd1bbb6666e99eeed5aa9ea8889acae99aaab38888002ea88cc11a1766aa33b4044334e277222e000000008202021e00000000000000000000000000000000
bbbd1bbb5665eeeee9999944a829bad9eb999be32022222eaaaaa1aa10777a334044433baa20227700000000e12221ee00000000000000000000000000000000
bbbd1bbbe55eeeeee999994eb99bbb9bbeeebe33707ddd8ecaaaaaca1111144b44044abbe220222200000000ee111eee00000000000000000000000000000000
bbb7fbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000333300000000000000000000000000
bb7e2fbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000838500000000000000000000000000
bbb7fbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000353000000000000000000000000000
bba009bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000033000000000000000000000000000
bbba9bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbba9bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbba9bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbba9bbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009aa900000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000499000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009aa4000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000990000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555555555000000eeeeeeeeee000000aaaaaaaaaa000000bbbbbbbbbb000000666666666600000000055550000000000006666000000000000111100000000
5000000000050000e2222222222e0000a9999999999a0000b3333333333b00006666666666660000005555555500000000666666660000000011000011000000
50000000000500002222222222220000999999999999000033333333333300006666666666660000055555555550000006666666666000000100000000100000
50000000000500002222222222220000999999999999000033333333333300006666666666660000055555555550000006666666666000000100000000100000
50000000000500002222222222220000999999999999000033333333333300006666666666660000555555555555000066666666666600001000000000010000
50000000000500002222222222220000999999999999000033333333333300006666666666660000555555555555000066666666666600001000000000010000
50000000000500002222222222220000999999999999000033333333333300006666666666660000555555555555000066666666666600001000000000010000
50000000000500002222222222220000999999999999000033333333333300006666666666660000555555555555000066666666666600001000000000010000
50000000000500002222222222220000999999999999000033333333333300006666666666660000055555555550000006666666666000000100000000100000
50000000000500002222222222220000999999999999000033333333333300006666666666660000055555555550000006666666666000000100000000100000
50000000000500001222222222210000199999999991000013333333333100006666666666660000005555555500000000666666660000000011000011000000
05555555555000000111111111100000011111111110000001111111111000000666666666600000000055550000000000006666000000000000111100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
055555555550000002222222222000000999999999900000033333333330000006666666666000000eeeeeeeeee000000aaaaaaaaaa000000bbbbbbbbbb00000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
55555555555500002222222222220000999999999999000033333333333300006666666666660000eeeeeeeeeeee0000aaaaaaaaaaaa0000bbbbbbbbbbbb0000
055555555550000002222222222000000999999999900000033333333330000006666666666000000eeeeeeeeee000000aaaaaaaaaa000000bbbbbbbbbb00000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e555555555555eee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5eeeeeeeeeeee5ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e555555555555eee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010203060708090a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004051716181900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000111213141500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
