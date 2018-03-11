/*
*  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing,
*  software distributed under the License is distributed on an
*  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*  KIND, either express or implied.  See the License for the
*  specific language governing permissions and limitations
*  under the License.
*/
package org.ballerinalang.nativeimpl.builtin.streamletlib;

import org.ballerinalang.bre.Context;
import org.ballerinalang.model.types.TypeKind;
import org.ballerinalang.model.values.BStreamlet;
import org.ballerinalang.model.values.BValue;
import org.ballerinalang.natives.AbstractNativeFunction;
import org.ballerinalang.natives.annotations.Argument;
import org.ballerinalang.natives.annotations.BallerinaFunction;

/**
 * {@code Stop} is the function to stop the streamlet runtime.
 *
 * @since 0.965.0
 */
@BallerinaFunction(packageName = "ballerina.builtin",
        functionName = "streamlet.stop",
        args = {
                @Argument(name = "s", type = TypeKind.STREAMLET)
        },
        isPublic = true)
public class Stop extends AbstractNativeFunction {

    @Override
    public BValue[] execute(Context context) {
        BStreamlet streamlet = (BStreamlet) getRefArgument(context, 0);
        streamlet.stopRuntime();
        return VOID_RETURN;
    }
}
