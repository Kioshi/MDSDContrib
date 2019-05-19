package dk.sdu.martinek.scoping

import com.google.inject.Inject
import dk.sdu.martinek.myDSL.impl.ModelImpl
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.scoping.impl.ImportNormalizer
import org.eclipse.xtext.scoping.impl.ImportedNamespaceAwareLocalScopeProvider

class MyDSLImportedNamespaceAwareLocalScopeProvider extends ImportedNamespaceAwareLocalScopeProvider {
	@Inject extension IQualifiedNameProvider

	// Take package from Model and add it with wildcard to namespace resolvers so other files with same packaged are explicitly included
	override protected List<ImportNormalizer> internalGetImportedNamespaceResolvers(EObject context, boolean ignoreCase) {
		val resolvers = super.internalGetImportedNamespaceResolvers(context, ignoreCase)
		if (context instanceof ModelImpl) {
			val fqn = context.fullyQualifiedName
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
