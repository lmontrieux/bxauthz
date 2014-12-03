package jp.ac.nii.prg.bxauthz.tests

import org.eclipse.xtext.junit4.util.ParseHelper
import jp.ac.nii.prg.bxauthz.bxAuthZ.Model
import com.google.inject.Inject
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import jp.ac.nii.prg.bxauthz.BxAuthZInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.junit.Test
import jp.ac.nii.prg.bxauthz.bxAuthZ.BxAuthZPackage
import jp.ac.nii.prg.bxauthz.validation.BxAuthZValidator

@InjectWith(BxAuthZInjectorProvider)
@RunWith(XtextRunner)

class ValidatorTest {
	@Inject extension ParseHelper<Model> parser
	@Inject extension ValidationTestHelper
	
	/**
	 * Empty policies are policies without any rule
	 */
	@Test
	def void testEmptyPolicy() {
		'''
		policy MyPolicy {
			subject MySubject
			transformation MyTransformation
		}
		'''.parse.assertWarning(
			BxAuthZPackage::eINSTANCE.policy,
			BxAuthZValidator.EMPTY_POLICY,
			"Policy contains no rule"
		)
	}
}