os.loadAPI("/api/crypto/primes")
os.loadAPI("/api/bigNum")

local ZERO = bigNum.BigNum.new("0")
local ONE = bigNum.BigNum.new("1")

local function modularInverse(a, n)
	local t = bigNum.BigNum.new(0)
	local newt = bigNum.BigNum.new(1)
	local r = bigNum.BigNum.new(n)
	local newr = bigNum.BigNum.new(a)
	local quotient = bigNum.BigNum.new(0)

	while not (newr == ZERO) do
		quotient = r/newr
		t, newt = newt, t - quotient * newt
		r, newr = newr, r - quotient * newr
	end
	print(r)
	if r > ONE then 
		error("a is not invertable")
	end
	if t < ZERO then 
		t = t + n
	end
	return t
end

local function modularPow(base, exponant, modulus)
	local result = ONE
	local i = ONE
	local base = bigNum.BigNum.new(base)
	local modulus = bigNum.BigNum.new(modulus)
	while i <= bigNum.BigNum.new(exponant) do
		result = (i*base) % modulus
		i = i + ONE
	end
	return result
end


function generateKeys()
	local p = primes.randomPrime()
	local q = primes.randomPrime()
	local n = p*q
	local phi = n-(p+q-1)

	local max_e = phi - 1

	if phi -1 > (math.pow(2, 31)-1) then
		max_e = math.pow(2, 31) -1
	end

	local e = math.random(max_e)

	while not primes.areCoprime(e, phi) do
		e = math.random(max_e)
	end

	local d = modularInverse(e, phi)

	local publicKey = {
		e = e,
		n = n}

	local privateKey = {
		e = e,
		n = n,
		d = d
	}
	return publicKey, privateKey
end

function encrypt(message, key)
	return modularPow(message, key.e, key.n)
end