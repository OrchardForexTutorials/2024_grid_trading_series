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

1.000  
Base starter version, buy and sell at each level

1.001 (from 1.000)  
Base updated to MT4 compatibility

1.002 (from 1.001)  
Add a trend filter based on consecutive candles in the same direction

1.003 (from 1.001)  
Code update, no functional change, to remove conditional blocks of code depending on buy or sell

1.004 (from 1.003)  
Added take profit and stop loss as optional inputs

1.005 (from 1.003)  
Close all trades when specified equity targets are reached

1.006 (from 1.005)  
Update to allow persistence of information following a restart

1.007 (from 1.006)  
Track profit on closed and open trades for the current expert

2.000 (from 1.003)
Also took some code from 1.007 for persistence  
This is an update to base code but changes behaviour so a change in major version number  
Added an input to allow trading buy/sell/none/both  
Moved more code to the leg base  
Changed names of base and custom class files to make them consistent with class names (this meant some restructure of include and minor upcates to old versions)

2.010 (from 2.000)  
Added inputs for high/low price to set a trading range

2.011 (based on 2.010)  
Use a high and low moving average to set the range limits

2.012 (based on 2.011)  
Make compatible with MT4

### Suggestions so far

Sorted according to profit and drawdown

<table>
	<thead><th colspan=2>Version</th><th>Profit</th><th>Abs Drawdown</th><th>Max Drawdown</th></thead>
	<tr> <td>1.000</td><td>Base</td>      <td>5,021</td> <td>578</td> <td>1,991</td> </tr>
	<tr> <td>2.011</td><td>Range MA 200 Hour</td>      <td>3,670</td> <td>329</td> <td>1,312</td> </tr>
	<tr> <td>1.005</td><td>Equity close at 10</td> <td>1,397</td>  <td>411</td> <td>674</td> </tr>
	<tr> <td>1.002</td><td>TP SL</td>                 <td>452</td>   <td>121</td> <td>542</td> </tr>
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
			The suggestion has come in many forms and there are 3 sub types that I will cover as different versions.
			The first version uses manually entered upper and lower limits and is a good idea because it allows you to
			use any analysis techniques to adjust the limits but it cannot be backtested for a result. The second uses
			a trend type indicator to set dynamic upper and lower limits and the third uses oscillators to only trade
			if the oscillator is in certain ranges.
		</td>
		<td>2.010<br/>2.011<br/>2.012<br/>2.013</td>
</table>
