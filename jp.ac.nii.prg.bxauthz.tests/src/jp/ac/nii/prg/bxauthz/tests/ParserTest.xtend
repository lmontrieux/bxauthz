package jp.ac.nii.prg.bxauthz.tests

import jp.ac.nii.prg.bxauthz.BxAuthZInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import javax.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import jp.ac.nii.prg.bxauthz.bxAuthZ.Model
import org.junit.Test

@InjectWith(BxAuthZInjectorProvider)
@RunWith(XtextRunner)

class ParserTest {
	@Inject extension ParseHelper<Model> parser
	@Inject extension ValidationTestHelper
	
	@Test
	def testEmptyPolicy() {
		'''
			policy MyPolicy {
				subject SubjectId001
				transformation calendar
			}
		'''.parse.assertNoErrors
	}
}