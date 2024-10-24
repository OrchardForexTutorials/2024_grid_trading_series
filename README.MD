### Warning

This is not to be used for live trading

### License

The project is released under [GNU GPLv3 licence](https://www.gnu.org/licenses/quick-guide-gplv3.html),
so that means the software is copyrighted, however you have the freedom to use, change or share the software
for any purpose as long as the modified version stays free. See: [GNU FAQ](https://www.gnu.org/licenses/gpl-faq.html).

You should have received a copy of the GNU General Public License along with this program
(check the [LICENSE] file).
If not, please read <http://www.gnu.org/licenses/>.
For simplified version, please read <https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)>.

## Terms of Use

By using this software, you understand and agree that we (company and author)
are not be liable or responsible for any loss or damage due to any reason.
Although every attempt has been made to assure accuracy,
we do not give any express or implied warranty as to its accuracy.
We do not accept any liability for error or omission.

You acknowledge that you are familiar with these risks
and that you are solely responsible for the outcomes of your decisions.
We accept no liability whatsoever for any direct or consequential loss arising from the use of this product.
You understand and agree that past results are not necessarily indicative of future performance.

Use of this software serves as your acknowledgement and representation that you have read and understand
these TERMS OF USE and that you agree to be bound by such Terms of Use ("License Agreement").

### Copyright information

Copyright © 2013-2024 - Novateq Pty Ltd - All Rights Reserved

### Disclaimer and Risk Warnings

Trading any financial market involves risk.
All forms of trading carry a high level of risk so you should only speculate with money you can afford to lose.
You can lose more than your initial deposit and stake.
Please ensure your chosen method matches your investment objectives,
familiarize yourself with the risks involved and if necessary seek independent advice.

NFA and CTFC Required Disclaimers:
Trading in the Foreign Exchange market as well as in Futures Market and Options or in the Stock Market
is a challenging opportunity where above average returns are available for educated and experienced investors
who are willing to take above average risk.
However, before deciding to participate in Foreign Exchange (FX) trading or in Trading Futures, Options or stocks,
you should carefully consider your investment objectives, level of experience and risk appetite.
**Do not invest money you cannot afford to lose**.

CFTC RULE 4.41 - HYPOTHETICAL OR SIMULATED PERFORMANCE RESULTS HAVE CERTAIN LIMITATIONS.
UNLIKE AN ACTUAL PERFORMANCE RECORD, SIMULATED RESULTS DO NOT REPRESENT ACTUAL TRADING.
ALSO, SINCE THE TRADES HAVE NOT BEEN EXECUTED, THE RESULTS MAY HAVE UNDER-OR-OVER COMPENSATED FOR THE IMPACT,
IF ANY, OF CERTAIN MARKET FACTORS, SUCH AS LACK OF LIQUIDITY. SIMULATED TRADING PROGRAMS IN GENERAL
ARE ALSO SUBJECT TO THE FACT THAT THEY ARE DESIGNED WITH THE BENEFIT OF HINDSIGHT.
NO REPRESENTATION IS BEING MADE THAN ANY ACCOUNT WILL OR IS LIKELY TO ACHIEVE PROFIT OR LOSSES SIMILAR TO THOSE SHOWN.

### Version History

Note: the latest version does not contain every earlier version. These versions are investigating different approaches
to grid trading and are not a continuous improvement. The note beside each version number (from or based on) indicates
the version that was used as the starting code for the version and does not mean that the features of the earlier
version are retained.

The list below shows the most recent version first.

2.030 (based on 2.000)
From a suggestion referencing a video by Expert4x which I can not find
Close the tail trade at each level,
apply the profit for the tail against a partial close minimum volume of the head.
This may give an overall profit or a loss if there are too many levels open.
Requires the initial volume to be large enough to allow for partial trading
This is a higher volume and therefore higher risk approach.

2.023 (based on 2.021)  
Average the head trade with profitable tail trades  
If the average profit of the head trade with the profitable tail trades is sufficient close those trades together.

2.022 (based on 2.021)  
Use the volume increment method but do not use the average close.  
Closing is the same as the original grid trader, each trade closes at the next level.

2.021 (based on 2.020)  
Increase the volume of trades based on the number of trades open  
Use inputs to specify the amount to increase the trade and number of trades to open before incrementing

2.020 (based on 2.000)  
An input to set an aveerage profit per lot as a target.
Then all trades for a leg are closed once the total profit for the leg reaches the target (adjusted for the total volume)

2.013 (based on 2.012)  
Changed from an trend indicator to an oscillator (RSI). Only buy if RSI is below a specified high and only sell if RSI os above the specified low  
Changed the folder structure in git, removed the Orchard folder from the top level and inserted Orchard under each of experts and includes. You can
now just copy the contents of experts to your experts folder and so on.

2.012 (based on 2.011)  
Make compatible with MT4

2.011 (based on 2.010)  
Use a high and low moving average to set the range limits. Only buy if price is below the range high, only sell if price is above range low.

2.010 (from 2.000)  
Added inputs for high/low price to set a trading range

2.000 (from 1.003)
Also took some code from 1.007 for persistence  
This is an update to base code but changes behaviour so a change in major version number  
Added an input to allow trading buy/sell/none/both  
Moved more code to the leg base  
Changed names of base and custom class files to make them consistent with class names (this meant some restructure of include and minor upcates to old versions)

1.007 (from 1.006)  
Track profit on closed and open trades for the current expert

1.006 (from 1.005)  
Update to allow persistence of information following a restart

1.005 (from 1.003)  
Close all trades when specified equity targets are reached

1.004 (from 1.003)  
Added take profit and stop loss as optional inputs

1.003 (from 1.001)  
Code update, no functional change, to remove conditional blocks of code depending on buy or sell

1.002 (from 1.001)  
Add a trend filter based on consecutive candles in the same direction

1.001 (from 1.000)  
Base updated to MT4 compatibility

1.000  
Base starter version, buy and sell at each level

### Suggestions so far

Sorted according to profit and drawdown

<table>
<thead><th colspan=2>Version</th><th>Profit</th><th>Abs Drawdown</th><th>Max Drawdown</th></thead>
<tr><td>1.000</td><td>Base</td><td>5,021</td><td>578</td><td>1,991</td></tr>
<tr><td>2.011</td><td>Range MA 200 Hour</td><td>3,670</td><td>329</td><td>1,312</td></tr>
<tr><td>2.020</td><td>Average price close</td><td>3,593</td><td>870</td><td>2,793</td></tr>
<tr><td>2.023</td><td>Average head trade</td><td>3,069</td><td>526</td><td>2,016</td></tr>
<tr><td>2.013</td><td>RSI 50/50</td><td>2,720</td><td>333</td><td>1,020</td></tr>
<tr><td>1.005</td><td>Equity close at 10</td><td>1,397</td><td>411</td><td>674</td></tr>
<tr><td>1.002</td><td>TP/SL</td><td>452</td><td>121</td><td>542</td></tr>
<tr><td>2.022</td><td>Incremental volume</td><td>66,464</td><td>4,149</td><td>22,679</td></tr>
<tr><td>2.021</td><td>Average close + incremental volume</td><td>11,261</td><td>6,694</td><td>6,985</td></tr>
</table>


<table>
	<thead><th>Suggestion</th><th>Comments</th><th>In Version</th></thead>
	<tr>
		<td>Button to stop expert and to close trades</td>
		<td>
			Manual intervention is not a bad suggestion and allows you to deal with market conditions but it is not something that
			can be readily demonstrated with the strategy tester. You can stop the expert by disabling auto trading or just removing
			the expert and you can manually close trades so I won't be writing any code for this suggestion
		</td>
		<td></td>
	</tr>
	<tr>
		<td>Trade with direction of different timeframe</td>
		<td>
			Given that the grid trader trades based on price movements I took this to man determine a direction trend using an
			alternate timeframe and only open new trades in that direction.
		</td>
		<td>1.0002</td>
	</tr>
	<tr>
		<td>Add take profit and stop loss</td>
		<td>
			The suggestion didn't go into more detail so I implemented this as a simple take profit and stop loss. The results are
			as expected but this might be starter code for you to build on the suggestion. Since the results can vary greatly
			depending on the inputs I haven't included the result in the table of results.
		</td>
		<td>1.0004</td>
	</tr>
	<tr>
		<td>Close all positions on hitting equity profit</td>
		<td>
			This suggestion is to wait until equity has increased by a specified amount, then close all open trades.
			This will reduce the total amount of trades held, and reduce swap paid, at the expense of lower profit
			but I haven't determined if the saving in swap will offset the reduced profit.
		</td>
		<td>1.0005</td>
	</tr>
	<tr>
		<td>Use range limits for buy and sell trades</td>
		<td>
			The suggestion has come in many forms and there are 3 sub types that I will cover as different versions.<br/>
			The first version uses manually entered upper and lower limits and is a good idea because it allows you to
			use any analysis techniques to adjust the limits but it cannot be backtested for a result. The grid trader
			will only buy if price is below the limit high and only sell of price is above the limit low.<br/>
			The second uses a trend type indicator to set dynamic upper and lower limits. The rules for buy and sell
			are the same as for the manual range<br/>
			The third uses oscillators to only buy if the oscillator value is below a specified high and only sell if the
			value is above the specified low. In this case the high and low are not prices because they are oscillator values
		</td>
		<td>2.010<br/>2.011<br/>2.012<br/>2.013</td>
	</tr>
	<tr>
		<td>Close positions at an average profit</td>
		<td>
			This suggestion came as 2 parts, close trades at an average profit and increase trade size as there are more levels.
			This is the first part where I apply the average profit close. The next part will add martingale to the
			position size and a third part will explore martingale without average close.
		</td>
		<td>2.020</td>
	</tr>
	<tr>
		<td>Close positions at an average profit with increasing trade size</td>
		<td>
			The second part of the suggestion for 2.020, close trades at an average profit and increase trade size as there are more levels.
			The code here increases trade size by a linear increment as each group of n trades are opened.
		</td>
		<td>2.021</td>
	</tr>
	<tr>
		<td>Increasing trade size without average close</td>
		<td>
			Based on the 2 earlier parts, just a quick update to see if there is a good result from applying the size increment without
			holding trades until the average is reached
		</td>
		<td>2.022</td>
	</tr>
	<tr>
		<td>Close tail positions in profit averaged with the head position</td>
		<td>
			Not so much a suggestion but an idea I had from the average close method. This will take the average profit of
			all trailing trades (low buys or high sells) that are in profit by more than the average plus the one leading trade
			and if the average of all of those meets the target average then close the profit trades and close the leading trade.
		</td>
		<td>2.023</td>
	</tr>
</table>
