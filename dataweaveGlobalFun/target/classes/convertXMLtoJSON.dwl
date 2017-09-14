%dw 1.0
			%output application/json
			%var tax=0.085
			%var discount=0.05
			---
			invoice: {
			    header: payload.invoice.header,
			    items: { (payload.invoice.items.*item map {
			        item @(index: $$ + 1): {
			            description: $.description,
			            quantity: $.quantity,
			            unit_price: $.unit_price,
			            discount: (discount * 100) as :number { format: "##" } ++ "%",
			            subtotal: $.unit_price * $.quantity * (1 - discount)
			        }
			    }) },
			    totals: using (subtotal = payload.invoice.items reduce ((item, sum1 = 0) -> sum1 + (item.unit_price * item.quantity * (1 - discount)))) {
			        subtotal: subtotal,
			        tax: (tax * 100) as :number { format: "##.#" } ++ "%",
			        total: subtotal * (1 + tax)
			    }
			}
				