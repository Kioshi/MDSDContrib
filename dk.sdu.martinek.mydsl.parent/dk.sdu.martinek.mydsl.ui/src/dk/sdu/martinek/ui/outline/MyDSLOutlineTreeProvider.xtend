/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.martinek.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import dk.sdu.martinek.myDSL.Headers
import dk.sdu.martinek.myDSL.Widgets
import dk.sdu.martinek.myDSL.Entities
import dk.sdu.martinek.myDSL.Layouts
import dk.sdu.martinek.myDSL.Layout
import dk.sdu.martinek.myDSL.Attribute
import dk.sdu.martinek.myDSL.MyStringValue
import dk.sdu.martinek.myDSL.MyIntConstant
import dk.sdu.martinek.myDSL.MyBoolConstant
import dk.sdu.martinek.myDSL.MyEntityIdentifier

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
class MyDSLOutlineTreeProvider extends DefaultOutlineTreeProvider {
		
	override Object _text(Object el)
	{
		switch el
		{
			Headers: return "Headers"
			Widgets: return "Widgets"
			Entities: return "Elements"
			Layouts: return "Layout"
			Layout: return el.ref.name
			Attribute: return el.ref.name + " = " + _text(el.right)
			MyStringValue: return el.^val
			MyIntConstant: return el.^val.toString
			MyBoolConstant: return el.^val
			MyEntityIdentifier: return el.ref.name
		}
		
		super._text(el)		
	}
	
		
}
