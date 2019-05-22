/*
 * generated by Xtext 2.16.0
 */
package dk.sdu.martinek.scoping

import dk.sdu.martinek.myDSL.Attribute
import dk.sdu.martinek.myDSL.Entity
import dk.sdu.martinek.myDSL.Layout
import dk.sdu.martinek.myDSL.MyDSLPackage
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 */
class MyDSLScopeProvider extends AbstractMyDSLScopeProvider {

	//@Inject extension MyDSLModelUtils
	
	override IScope getScope(EObject context, EReference reference) {
		
		if (reference == MyDSLPackage.Literals.ATTRIBUTE__REF)
		{
			// Entity attribute hint scope
			if (context instanceof Entity)
			{
				return Scopes.scopeFor(context.ref.properties)
			}
			
			// Entity attribute normal scope
			if (context instanceof Attribute)
			{
				return Scopes.scopeFor((context.eContainer as Entity).ref.properties)
			}
		}
		
		// No need to change scope
		if (( context instanceof Layout && reference == MyDSLPackage.Literals.LAYOUT__REF)
		   ||(context instanceof Entity && reference == MyDSLPackage.Literals.ENTITY__REF)
		   ||(context instanceof Attribute && reference == MyDSLPackage.Literals.MY_ENTITY_IDENTIFIER__REF)
		)
		{
			return super.getScope(context, reference)			
		}
		
		 
		super.getScope(context, reference)
	}	
}
