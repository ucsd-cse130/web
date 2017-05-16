
let parse_string str =
	let lb = Lexing.from_string str
	in
		BeParser.expr BeLexer.token lb
		
let token_list_of_string s =
	let lb = Lexing.from_string s in
	let rec helper l =
		try
			let t = BeLexer.token lb in
			if t = BeParser.EOF then List.rev l else helper (t::l)
		with _ -> List.rev l
	in 
		helper []