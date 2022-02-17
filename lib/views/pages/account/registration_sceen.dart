import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kixat/bloc/register_bloc.dart';
import 'package:kixat/views/customWidget/CustomAppBar.dart';
import 'package:kixat/views/customWidget/CustomButton.dart';
import 'package:kixat/views/customWidget/CustomCheckBox.dart';
import 'package:kixat/views/customWidget/CustomDropdown.dart';
import 'package:kixat/views/customWidget/error.dart';
import 'package:kixat/views/customWidget/loading.dart';
import 'package:kixat/views/customWidget/loading_dialog.dart';
import 'package:kixat/model/AvailableOption.dart';
import 'package:kixat/model/GetAvatarResponse.dart';
import 'package:kixat/model/RegisterFormResponse.dart';
import 'package:kixat/networking/ApiResponse.dart';
import 'package:kixat/views/pages/account/change_password_screen.dart';
import 'package:kixat/service/GlobalService.dart';
import 'package:kixat/utils/ButtonShape.dart';
import 'package:kixat/utils/Const.dart';
import 'package:kixat/utils/CustomAttributeManager.dart';
import 'package:kixat/utils/ValidationMixin.dart';
import 'package:kixat/utils/extensions.dart';
import 'package:kixat/utils/shared_pref.dart';
import 'package:kixat/utils/utility.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = '/registration';
  final RegistrationScreenArguments screenArgument;

  const RegistrationScreen({Key key, this.screenArgument}) : super(key: key);

  @override
  _RegistrationScreenState createState() =>
      _RegistrationScreenState(screenArgument);
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with ValidationMixin {
  final RegistrationScreenArguments screenArgument;
  bool isRegistrationMode;
  GlobalService _globalService = GlobalService();
  RegisterBloc _bloc;
  CustomAttributeManager attributeManager;
  final _formKey = GlobalKey<FormState>();

  _RegistrationScreenState(this.screenArgument) {
    isRegistrationMode = !screenArgument.getCustomerInfo;
  }

  @override
  void initState() {
    super.initState();

    _bloc = RegisterBloc();

    if (isRegistrationMode) {
      _bloc.fetchRegisterFormData();
    } else {
      _bloc.fetchCustomerInfo();

      if (_globalService.getAppLandingData().allowCustomersToUploadAvatars ==
          true) _bloc.fetchCustomerAvatar();
    }

    _bloc.registerResponseStream.listen((event) async {
      if (event.status == Status.COMPLETED) {
        DialogBuilder(context).hideLoader();

        if (isRegistrationMode) {
          showSnackBar(context, event?.data?.message ?? '', false);
          // close the screen
          await Future.delayed(Duration(microseconds: 250));
          Navigator.of(context).pop();
        } else {
          showSnackBar(context,
              _globalService.getString(Const.UPDATED_SUCCESSFULLY), false);
          // Save updated info to disk
          var info = await SessionData().getCustomerInfo();

          info
            ..firstName = event?.data?.data?.firstName ?? ''
            ..lastName = event?.data?.data?.lastName ?? ''
            ..email = event?.data?.data?.email ?? ''
            ..username = event?.data?.data?.username ?? '';

          SessionData().setCustomerInfo(info);
        }
      } else if (event.status == Status.ERROR) {
        DialogBuilder(context).hideLoader();
        showSnackBar(context, event.message, true);
      } else if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      }
    });

    _bloc.statesListStream.listen((event) {
      if (event.status == Status.LOADING) {
        DialogBuilder(context).showLoader();
      } else {
        DialogBuilder(context).hideLoader();
      }
    });

    attributeManager = CustomAttributeManager(
      context: context,
      onClick: (priceAdjNeeded) {
        setState(() {
          // updating UI to show selected attribute values
        });
      },
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: isRegistrationMode
            ? Text(_globalService.getString(Const.TITLE_REGISTER))
            : Text(_globalService.getString(Const.ACCOUNT_INFO)),
      ),
      body: StreamBuilder<ApiResponse<RegisterFormData>>(
        stream: _bloc.registerFormStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Loading(loadingMessage: snapshot.data.message);
                break;
              case Status.COMPLETED:
                return populateRegisterForm(snapshot.data.data);
                break;
              case Status.ERROR:
                return Error(
                  errorMessage: snapshot.data.message,
                  onRetryPressed: () => isRegistrationMode
                      ? _bloc.fetchRegisterFormData()
                      : _bloc.fetchCustomerInfo(),
                );
                break;
            }
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget populateRegisterForm(RegisterFormData formData) {
    final tfFirstName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.firstNameEnabled &&
            formData.firstNameRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FIRST_NAME);
        }
        return null;
      },
      onChanged: (value) => formData.firstName = value,
      initialValue: formData.firstName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.FIRST_NAME,
          formData.firstNameEnabled && formData.firstNameRequired),
    );

    final tfLastName = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.lastNameEnabled &&
            formData.lastNameRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.LAST_NAME);
        }
        return null;
      },
      onChanged: (value) => formData.lastName = value,
      initialValue: formData.lastName,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.LAST_NAME,
          formData.lastNameEnabled && formData.lastNameRequired),
    );

    final tfEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty || !isValidEmailAddress(value)) {
          return _globalService.getString(Const.EMAIL);
        }
        return null;
      },
      onChanged: (value) => formData.email = value,
      initialValue: formData.email,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.EMAIL, true),
    );

    final tfConfirmEmail = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if ((formData.enteringEmailTwice ?? false) &&
            (value == null || value.isEmpty || !isValidEmailAddress(value))) {
          return _globalService.getString(Const.CONFIRM_EMAIL);
        }
        return null;
      },
      onChanged: (value) => formData.confirmEmail = value,
      initialValue: formData.confirmEmail,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.CONFIRM_EMAIL, true),
    );

    final tfUsername = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.usernamesEnabled && (value == null || value.isEmpty)) {
          return _globalService.getString(Const.USERNAME);
        }
        return null;
      },
      onChanged: (value) => formData.username = value,
      initialValue: formData.username,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.USERNAME, formData.usernamesEnabled),
    );

    final tfCompany = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.companyEnabled &&
            formData.companyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.COMPANY);
        }
        return null;
      },
      onChanged: (value) => formData.company = value,
      initialValue: formData.company,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.COMPANY, formData.companyEnabled && formData.companyRequired),
    );

    final tfStreet1 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddressEnabled &&
            formData.streetAddressRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS);
        }
        return null;
      },
      onChanged: (value) => formData.streetAddress = value,
      initialValue: formData.streetAddress,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS,
          formData.streetAddressEnabled && formData.streetAddressRequired),
    );

    final tfStreet2 = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.streetAddress2Enabled &&
            formData.streetAddress2Required &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.STREET_ADDRESS_2);
        }
        return null;
      },
      onChanged: (value) => formData.streetAddress2 = value,
      initialValue: formData.streetAddress2,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.STREET_ADDRESS_2,
          formData.streetAddress2Enabled && formData.streetAddress2Required),
    );

    final tfZip = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (value) {
        if (formData.zipPostalCodeEnabled &&
            formData.zipPostalCodeRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ZIP_CODE);
        }
        return null;
      },
      onChanged: (value) => formData.zipPostalCode = value,
      initialValue: formData.zipPostalCode,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ZIP_CODE,
          formData.zipPostalCodeEnabled && formData.zipPostalCodeRequired),
    );

    final tfCounty = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.countyEnabled &&
            formData.countyRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.ADDRESS_COUNTY);
        }
        return null;
      },
      onChanged: (value) => formData.county = value,
      initialValue: formData.county,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.ADDRESS_COUNTY,
          formData.countyEnabled && formData.countyRequired),
    );

    final tfCity = TextFormField(
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (formData.cityEnabled &&
            formData.cityRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.CITY);
        }
        return null;
      },
      onChanged: (value) => formData.city = value,
      initialValue: formData.city,
      textInputAction: TextInputAction.next,
      decoration:
          inputDecor(Const.CITY, formData.cityEnabled && formData.cityRequired),
    );

    final tfPhone = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.phoneEnabled &&
            formData.phoneRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.PHONE);
        }
        return null;
      },
      onChanged: (value) => formData.phone = value,
      initialValue: formData.phone,
      textInputAction: TextInputAction.next,
      decoration: inputDecor(
          Const.PHONE, formData.phoneEnabled && formData.phoneRequired),
    );

    final tfFax = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      validator: (value) {
        if (formData.faxEnabled &&
            formData.faxRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.FAX);
        }
        return null;
      },
      onChanged: (value) => formData.fax = value,
      initialValue: formData.fax,
      textInputAction: TextInputAction.next,
      decoration:
          inputDecor(Const.FAX, formData.faxEnabled && formData.faxRequired),
    );

    final tfDOB = TextFormField(
      key: UniqueKey(),
      keyboardType: TextInputType.text,
      autofocus: false,
      readOnly: true,
      initialValue: getFormattedDate(_bloc.userDob),
      validator: (value) {
        if (formData.dateOfBirthEnabled &&
            formData.dateOfBirthRequired &&
            (value == null || value.isEmpty)) {
          return _globalService.getString(Const.DATE_OF_BIRTH);
        }
        return null;
      },
      onSaved: (newValue) {
        if (_bloc.userDob != null) {
          formData.dateOfBirthDay = _bloc.userDob.day;
          formData.dateOfBirthMonth = _bloc.userDob.month;
          formData.dateOfBirthYear = _bloc.userDob.year;
        }
      },
      onTap: () => _selectDate(),
      textInputAction: TextInputAction.next,
      decoration: inputDecor(Const.DATE_OF_BIRTH,
          formData.dateOfBirthEnabled && formData.dateOfBirthRequired),
    );

    var countryDropDown = formData.countryEnabled
        ? CustomDropdown<AvailableOption>(
            onChanged: (value) {
              setState(() {
                _bloc.selectedCountry = value;
                formData.countryId = int.tryParse(value.value);
                _bloc.fetchStatesByCountryId(formData.countryId);
              });
            },
            onSaved: (newValue) {
              _bloc.selectedCountry = newValue;
              formData.countryId = int.tryParse(newValue.value);
            },
            validator: (value) {
              if (formData.countryEnabled &&
                  formData.countryRequired &&
                  (value == null || value.value == '0'))
                return _globalService.getString(Const.COUNTRY_REQUIRED);
              return null;
            },
            preSelectedItem: _bloc.selectedCountry,
            items: formData.availableCountries
                    ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                        DropdownMenuItem<AvailableOption>(
                            value: e, child: Text(e.text)))
                    ?.toList() ??
                List.empty(),
          )
        : SizedBox.shrink();

    var stateDropDown = formData.stateProvinceEnabled
        ? CustomDropdown<AvailableOption>(
            onChanged: (value) {
              setState(() {
                _bloc.selectedState = value;
                formData.stateProvinceId = int.tryParse(value.value);
              });
            },
            onSaved: (newValue) {
              _bloc.selectedState = newValue;
              formData.stateProvinceId = int.tryParse(newValue.value);
            },
            validator: (value) {
              if (formData.stateProvinceEnabled &&
                  formData.stateProvinceRequired &&
                  value == null)
                return _globalService.getString(Const.STATE_REQUIRED);
              return null;
            },
            preSelectedItem: _bloc.cachedData.availableStates?.safeFirstWhere(
              (element) => element.selected ?? false,
              orElse: () => formData.availableStates?.safeFirst(),
            ),
            items: _bloc.cachedData.availableStates
                    ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                        DropdownMenuItem<AvailableOption>(
                            value: e, child: Text(e.text)))
                    ?.toList() ??
                List.empty(),
          )
        : SizedBox.shrink();

    var tzDropDown = formData.allowCustomersToSetTimeZone
        ? CustomDropdown<AvailableOption>(
            onChanged: (value) {
              setState(() {
                _bloc.selectedTimeZone = value;
                formData.timeZoneId = int.tryParse(value.value);
              });
            },
            onSaved: (newValue) {
              _bloc.selectedTimeZone = newValue;
              formData.timeZoneId = int.tryParse(newValue.value);
            },
            preSelectedItem: _bloc.selectedTimeZone,
            items: formData.availableTimeZones
                    ?.map<DropdownMenuItem<AvailableOption>>((e) =>
                        DropdownMenuItem<AvailableOption>(
                            value: e, child: Text(e.text)))
                    ?.toList() ??
                List.empty(),
          )
        : SizedBox.shrink();

    var radioGender = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 48,
          child: Center(
            child: Text(
              _globalService.getString(Const.GENDER),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              Radio<String>(
                value: "M",
                groupValue: formData.gender,
                onChanged: (value) {
                  setState(() {
                    formData.gender = value;
                  });
                },
              ),
              Text(_globalService.getString(Const.GENDER_MALE)),
            ],
          ),
        ),
        SizedBox(
          child: Row(
            children: [
              Radio<String>(
                value: "F",
                groupValue: formData.gender,
                onChanged: (value) {
                  setState(() {
                    formData.gender = value;
                  });
                },
              ),
              Text(_globalService.getString(Const.GENDER_FEMALE)),
            ],
          ),
        ),
      ],
    );

    var btnRegister = CustomButton(
        label: isRegistrationMode
            ? _globalService.getString(Const.REGISTER_BUTTON).toUpperCase()
            : _globalService.getString(Const.SAVE_BUTTON).toUpperCase(),
        shape: ButtonShape.RoundedTop,
        onClick: () {
          removeFocusFromInputField(context);

          String errMsg = attributeManager
              .checkRequiredAttributes(formData.customerAttributes);
          if (errMsg.isNotEmpty) {
            showSnackBar(context, errMsg, true);
          } else if ((formData.acceptPrivacyPolicyEnabled ?? false) &&
              !_bloc.privacyAccepted) {
            showSnackBar(context,
                _globalService.getString(Const.REGISTER_ACCEPT_PRIVACY), true);
          } else {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              if (isRegistrationMode) {
                _bloc.postRegisterFormData(
                    formData,
                    attributeManager
                        .getSelectedAttributes('customer_attribute'));
              } else {
                _bloc.posCustomerInfo(
                    formData,
                    attributeManager
                        .getSelectedAttributes('customer_attribute'));
              }
            }
          }
        });

    var avatarSection = [
      SizedBox(height: 10),
      StreamBuilder<ApiResponse<GetAvatarData>>(
          stream: _bloc.avatarStream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.status == Status.COMPLETED)
              return CircleAvatar(
                backgroundImage:
                    snapshot.data?.data?.avatarUrl?.isNotEmpty == true
                        ? NetworkImage(snapshot.data?.data?.avatarUrl ?? '')
                        : AssetImage('assets/user.png'),
                backgroundColor: Colors.grey[200],
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PopupMenuButton(
                    icon: Icon(Icons.edit_outlined),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                              _globalService.getString(Const.COMMON_UPLOAD)),
                        ),
                        if (snapshot.data?.data?.avatarUrl?.isNotEmpty == true)
                          PopupMenuItem(
                            value: 2,
                            child: Text(_globalService
                                .getString(Const.ACCOUNT_REMOVE_AVATAR)),
                          )
                      ];
                    },
                    onSelected: (int index) async {
                      if (index == 1) {
                        // upload
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          // type: FileType.image,
                          allowMultiple: false,
                        );

                        var maxSize = _globalService
                            .getAppLandingData()
                            .avatarMaximumSizeBytes;

                        if (result != null &&
                            result.files.single.size > maxSize) {
                          var msg = _globalService.getStringWithNumber(
                              Const.ACCOUNT_AVATAR_SIZE,
                              _globalService
                                      .getAppLandingData()
                                      .avatarMaximumSizeBytes ??
                                  50);
                          showSnackBar(context, msg, true);
                        } else if (result != null &&
                            result.files.single.size < maxSize) {
                          _bloc.uploadAvatar(result.files.single.path);
                        }
                      } else if (index == 2) {
                        // remove
                        _bloc.removeAvatar();
                      }
                    },
                  ),
                ),
                radius: 50,
              );
            else
              return SizedBox.shrink();
          }),
    ];

    return Form(
      key: _formKey,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isRegistrationMode &&
                      _globalService
                              .getAppLandingData()
                              .allowCustomersToUploadAvatars ==
                          true)
                    ...avatarSection,
                  sectionTitle(_globalService
                      .getString(Const.REGISTRATION_PERSONAL_DETAILS)),
                  if (formData.firstNameEnabled) tfFirstName,
                  if (formData.lastNameEnabled) tfLastName,
                  if (formData.usernamesEnabled) tfUsername,
                  if (formData.dateOfBirthEnabled) tfDOB,
                  tfEmail,
                  if (formData.enteringEmailTwice ?? false) tfConfirmEmail,
                  if (formData.genderEnabled) radioGender,
                  if (formData.countryEnabled) countryDropDown,
                  if (formData.stateProvinceEnabled) stateDropDown,
                  if (formData.allowCustomersToSetTimeZone) tzDropDown,
                  if (formData.phoneEnabled) tfPhone,
                  if (formData.faxEnabled) tfFax,
                  if (formData.streetAddressEnabled) tfStreet1,
                  if (formData.streetAddress2Enabled) tfStreet2,
                  if (formData.zipPostalCodeEnabled) tfZip,
                  if (formData.countyEnabled) tfCounty,
                  if (formData.cityEnabled) tfCity,
                  if (formData.companyEnabled) tfCompany,
                  checkboxAndGdprConsent(formData),
                  attributeManager
                      .populateCustomAttributes(formData.customerAttributes),
                  SizedBox(height: 10),
                  if (isRegistrationMode) passwordSection(formData),
                  if (!isRegistrationMode) changePasswordSection(),
                  SizedBox(height: 60), // margin for button
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [Expanded(child: btnRegister)],
            ),
          )
        ],
      ),
    );
  }

  Widget checkboxAndGdprConsent(RegisterFormData formData) {
    return Column(
      children: [
        if (formData.newsletterEnabled ?? false)
          CustomCheckBox(
            onTap: () {
              setState(() {
                formData.newsletter = !formData.newsletter;
              });
            },
            isChecked: formData.newsletter ?? false,
            label: _globalService.getString(Const.NEWSLETTER),
          ),
        if (formData.acceptPrivacyPolicyEnabled ?? false)
          CustomCheckBox(
            onTap: () {
              setState(() {
                formData.acceptPrivacyPolicyPopup =
                    !formData.acceptPrivacyPolicyPopup;
              });
            },
            isChecked: formData.acceptPrivacyPolicyPopup,
            label: _globalService.getString(Const.ACCEPT_PRIVACY_POLICY),
          ),
      ],

      // TODO GDPR consent
    );
  }

  Widget passwordSection(RegisterFormData formData) {
    return Column(
      children: [
        sectionTitle(_globalService.getString(Const.REGISTRATION_PASSWORD)),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autofocus: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _globalService.getString(Const.ENTER_PASSWORD);
            }
            return null;
          },
          onChanged: (value) => formData.password = value,
          initialValue: formData.password,
          textInputAction: TextInputAction.next,
          decoration: inputDecor(Const.ENTER_PASSWORD, true),
        ),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autofocus: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return _globalService.getString(Const.CONFIRM_PASSWORD);
            }
            return null;
          },
          onChanged: (value) => formData.confirmPassword = value,
          initialValue: formData.confirmPassword,
          textInputAction: TextInputAction.done,
          decoration: inputDecor(Const.CONFIRM_PASSWORD, true),
        ),
      ],
    );
  }

  Widget changePasswordSection() => Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName),
          child: Text(
            _globalService.getString(Const.CHANGE_PASSWORD),
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  fontSize: 17,
                ),
          ),
        ),
      );

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        getDivider()
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: _bloc.userDob == null ? DateTime.now() : _bloc.userDob,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());

    if (pickedDate != null)
      setState(() {
        _bloc.userDob = pickedDate;
      });
  }
}

class RegistrationScreenArguments {
  bool getCustomerInfo;

  RegistrationScreenArguments({@required this.getCustomerInfo});
}
