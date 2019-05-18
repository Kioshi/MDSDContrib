package dk.sdu.martinek.scoping

import org.eclipse.xtext.naming.DefaultDeclarativeQualifiedNameProvider
import org.eclipse.xtext.naming.QualifiedName
import dk.sdu.martinek.myDSL.Entity
import dk.sdu.martinek.myDSL.impl.MyEntityIdentifierImpl
import javax.lang.model.element.QualifiedNameable

class MyQualifiedNameProvider extends DefaultDeclarativeQualifiedNameProvider
{
    override QualifiedName qualifiedName(Object e) {
        //val p = (Package) e.eContainer();
        /*
        if (e instanceof MyEntityIdentifierImpl)
        {
        	return QualifiedName.create("test",e.ref.name);
        }
        */
        return null//QualifiedName.create(p.getName(), e.getId());
    }
	
}