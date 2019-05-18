package dk.sdu.martinek.scoping

import com.google.inject.Inject
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider
import dk.sdu.martinek.myDSL.Entity
import dk.sdu.martinek.myDSL.impl.MyEntityIdentifierImpl
import dk.sdu.martinek.myDSL.impl.EntityImpl
import java.util.ArrayList
import dk.sdu.martinek.myDSL.MyEntityIdentifier

class MyDSLImportedNamespaceAwareLocalScopeProvider extends ImportedNamespaceAwareLocalScopeProvider {
	@Inject extension IQualifiedNameProvider

	override getImplicitImports(boolean ignoreCase) {
		newArrayList(new ImportNormalizer(
			//QualifiedName.create("smalljava", "lang"),
			QualifiedName.create("main"),
			true, // wildcard
			ignoreCase
		))
	}

	override protected List<ImportNormalizer> internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {
		val resolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase)
		if (context instanceof Entity) {
			val fqn = context.fullyQualifiedName
			val container = context.eContainer
			
			if (container instanceof MyEntityIdentifierImpl)
			{
				val newFqn = new ArrayList<String>(fqn.segments);
				if (newFqn.length > 1)
				{
					newFqn.remove(newFqn.length - 1);					
				}
				resolvers += new ImportNormalizer(
					QualifiedName.create(newFqn),
					true, // use wildcards
					ignoreCase
				)				
			}
			
			// fqn is the package of this program
			if (fqn !== null) {
				// all the external classes with the same package of this program
				// will be automatically visible in this program, without an import
				resolvers += new ImportNormalizer(
					fqn,
					true, // use wildcards
					ignoreCase
				)
			}
		}
		return resolvers
	}

}
