# Curve-like StableSwap

## Basic concept

Whats the point of using a stable-swap instead a regular exchange? Well , this stableswaps have less slippage because it uses an algorithm that mixes CPAMM(Constant Product Automated Market Maker) and CSAMM(Constant Sum Automated Market Maker). But, why it doesn't directly use the CSAMM? That way yo ucould het 1000 DAI for 1000 USDT with no slippage...in a perfect world. In reality, stablecoins aren't perfectly pegged to 1$ price so they are not all worth exactly the same. This graphic shows the slippage of Curve vs Uniswap.

![alt text](https://github.com/XabierOterino/Stable-Swap/blob/main/img/Captura%20de%20pantalla%202022-09-14%20181209.png)

## Math behind

Lets start with the simplest equation ,the constant sum : amount of x + amount of y equals constant D

```shell
x + y = D
```

Then we got the constant product formula:

```shell
x + y = (D / 2)^2
```

Comning the equations above we get:

```shell
x + y + xy = D + (D / 2)^2
```

But this equation looks more like the Uniswap curve, and we want it to be flat in the middle. We acomplish this by inserting a Chi(χ) variable multiplying by (x + y) and D which should be equal.

```shell
χ *(x + y) + xy = χ *(D) + (D / 2)^2
```

If Chi tends to infinity the the other elements are irrelevant, and the equation will look like this:(similar to CSAMM)

```shell
χ *(x + y) = χ *(D)
```

Otherwise , if Chi tends to null , the equation is simplified like this:(CPAMM)

```shell
xy =  (D / 2)^2
```

Assuming that , the bigger is Chi the flatter is the curve and the smaller is Chi the more curver.
Now we can express that with a simpler equation:

```shell
χ * ((x + y) / D) = χ * D
```

So now if we put that into the longer equation [ χ *(x + y) + xy = χ *(D) + (D / 2)^2 ] it looks like this:

```shell
Dχ *(x + y) + xy = χ *(D * D) + (D / 2)^2
```

Which is the same as Curve whitepaper's :
